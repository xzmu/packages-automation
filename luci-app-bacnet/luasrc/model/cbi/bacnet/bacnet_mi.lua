--[[
LuCI - Lua Configuration Interface

Copyright 2012 Patrick Grimm <patrick@lunatiki.de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

require("luci.sys")
require("luci.util")
require("luci.tools.webadmin")
require("nixio.fs")
local arg1 = arg[1]
local uci = luci.model.uci.cursor()
local uci_state = luci.model.uci.cursor_state()

if not nixio.fs.access("/etc/config/bacnet_mi") then
	if not luci.sys.exec("touch /etc/config/bacnet_mi") then
		return
	end
end

local events = {}
events[1] = {0,"Keine Ereignis Behandlung"}
events[2] = {1,"Ereignis"}
events[3] = {2,"Ereignis"}
events[4] = {3,"Ereignis"}
events[5] = {4,"Ereignis"}
events[6] = {5,"Ereignis"}
events[7] = {6,"Ereignis"}
events[8] = {7,"Alle Ereignis behandeln"}

if arg1 then
	m = Map("bacnet_mi_"..arg1, "Bacnet Multisate Input", "Bacnet Multisate Input Configuration")
else
	m = Map("bacnet_mi", "Bacnet Multisate Input", "Bacnet Multisate Input Configuration")
end

s = m:section(TypedSection, "mi", arg1 or 'Index')
s.addremove = true
s.anonymous = false
s.template = "cbi/tblsection"

s:option(Flag, "disable", "Disable")
s:option(Flag, "Out_Of_Service", "Out Of Service")
s:option(Value, "name", "Name")

sva = s:option(Value, "tagname",  "Zugrifsname")
uci:foreach("linknx", "daemon",
	function (section)
			sva:value(section.tagname)
	end)
uci:foreach("modbus", "station",
	function (section)
			sva:value(section.tagname)
	end)
sva:value("icinga")

local sva = s:taboption("io", Value, "unit_id", "Unit ID")
sva:value('1')
sva:value('255')
sva.rmempty = true
sva:value('1',"Spulen (Coils)")
sva:value('2',"Diskrete Eingäng (Disc Inputs)")
sva:value('3',"Halteregister (Holding Register)")
sva:value('4',"Eingaberegister (Input Register) Default")
sva.rmempty = true
s:option(Value, "addr", "Addr")
s:option(Value, "value", "Value")
s:option(DynamicList, "state", "Stats")
s:option(DynamicList, "alarmstate", "Alarm Stats")

sva = s:option(Value, "group",  "Gruppe")
local uci = luci.model.uci.cursor()
uci:foreach("bacnet_group", "group",
	function (section)
			sva:value(section.name)
	end)

s:option(Value, "description", "Anzeige Name")
s:option(Flag, "tl", "Trend Log")
svc = s:option(Value, "nc", "Notification Class")
svc.rmempty = true
local uci = luci.model.uci.cursor()
uci:foreach("bacnet_nc", "nc",
	function (section)
			sva:value(section,section.name)
	end)
sva = s:option(Value, "event",  "BIT1 Alarm,BIT2 Fehler,BIT3 Alarm oder Fehler geht [7]")
for i, v in ipairs(events) do
	sva:value(v[1],v[1]..": "..v[2])
end
local sva = s:option(Value, "value_time", "value_time")

return m


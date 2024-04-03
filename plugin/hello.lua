print("stnv debug module loaded. use :lua create_debug_split()")

attach_to_buffer = function(output_bufnr, pattern, command)
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("Luapocs", { clear = true }),
  pattern = pattern,
  callback = function()
    local append_data = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
      end
    end

    vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, flase, { "===== EXECUTION WINDOW =====" })
    vim.fn.jobstart(command, {
      stdout_buffered = true,
      on_stdout = append_data,
      on_stderr = append_data,
    })
  end,
})
end

stnv_help = function()
  print('example:lua attach_to_buffer(3, "*.py", { "python3", "test.py" })')
end

debug_help = function()
  print('example:lua create_vsplit()')
end


create_debug_split = function()
    -- Save the current buffer number
    local current_win = vim.api.nvim_get_current_win()
    local fname =  vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')

    local lang_dict = {
      ["py"] = "python ",
      ["go"] = "go run",
      ["lua"] = "lua ",
    }
    -- Create a vsplit
    vim.cmd('vsplit debug_window')
    local new_bufnr = vim.api.nvim_get_current_buf()
    
    -- Go back to the original buffer
    -- vim.api.nvim_set_current_buf(current_bufnr)
    -- Return the buffer number of the new split
    print(new_bufnr, "*."..extension ,lang_dict[extension]..fname)
    attach_to_buffer(new_bufnr, "*."..extension, lang_dict[extension]..fname)
    vim.api.nvim_set_current_win(current_win)
    return new_bufnr
end

-- attach_to_buffer(3, "*.py", { "python3", "test.py" })
-- attach_to_buffer(3, "*.go", { "go run", "main.go" })
-- attach_to_buffer(4, "*.lua", { "lua", "filename.lua" })

open_buffer_in_new_tab = function()
  local current_buffer_number = vim.api.nvim_get_current_buf()
  vim.cmd('tab sb'..current_buffer_number)
end
vim.api.nvim_set_keymap('n', '<A-t>', ':lua open_buffer_in_new_tab()<CR>', {noremap = true})

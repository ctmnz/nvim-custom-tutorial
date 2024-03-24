print("Hello there!")

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

print_buffer = function()
  print(vim.api.nvim_get_current_buf())
end

stnv_help = function()
  print('example:lua attach_to_buffer(3, "*.py", { "python3", "test.py" })')



-- attach_to_buffer(3, "*.py", { "python3", "test.py" })
-- attach_to_buffer(3, "*.lua", { "lua", "filename.lua" })

local rspec =
  io.popen('sh ~/scripts/git-stuff/get-files-rspec.sh noclipboard')
  :read('*a')
  :gsub('\n', '')

vim.fn.VtrSendCommand(rspec)

print('Getting spec files from diff with main/master and running rspec')

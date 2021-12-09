local rubocop =
  io.popen('sh ~/scripts/git-stuff/get-files-rubocop.sh noclipboard')
  :read('*a')
  :gsub('\n', '')

vim.fn.VtrSendCommand(rubocop)

print('Getting files from diff with main/master and running rubocop')

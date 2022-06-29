function nmap(lhs, rhs, opts) vim.keymap.set('n', lhs, rhs, opts) end

function imap(lhs, rhs, opts) vim.keymap.set('i', lhs, rhs, opts) end

nmap('<c-s>', ':w<CR>')

local ol = vim.opt_local

ol.suffixesadd:prepend('.lua')
ol.suffixesadd:prepend('init.lua')
ol.path:prepend(vim.fn.stdpath('config') .. '/lua')

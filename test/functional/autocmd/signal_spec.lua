local helpers = require('test.functional.helpers')(after_each)

local clear = helpers.clear
local command = helpers.command
local eq = helpers.eq
local funcs = helpers.funcs
local next_msg = helpers.next_msg
local iswin = helpers.iswin
local skip = helpers.skip

if skip(iswin(), 'Only applies to POSIX systems') then return end

local function posix_kill(signame, pid)
  os.execute('kill -s '..signame..' -- '..pid..' >/dev/null')
end

describe('autocmd Signal', function()
  before_each(clear)

  it('matches *', function()
    command('autocmd Signal * call rpcnotify(1, "foo")')
    posix_kill('USR1', funcs.getpid())
    eq({'notification', 'foo', {}}, next_msg())
  end)

  it('matches SIGUSR1', function()
    command('autocmd Signal SIGUSR1 call rpcnotify(1, "foo")')
    posix_kill('USR1', funcs.getpid())
    eq({'notification', 'foo', {}}, next_msg())
  end)

  it('matches SIGWINCH', function()
    command('autocmd Signal SIGWINCH call rpcnotify(1, "foo")')
    posix_kill('WINCH', funcs.getpid())
    eq({'notification', 'foo', {}}, next_msg())
  end)

  it('does not match unknown patterns', function()
    command('autocmd Signal SIGUSR2 call rpcnotify(1, "foo")')
    posix_kill('USR1', funcs.getpid())
    eq(nil, next_msg(500))
  end)
end)

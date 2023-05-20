if status is-interactive

    # Setup WSL2 to use windows ssh agent, requires socat and npiperelay
    if echo (uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip') | grep -qi "Microsoft"
        set -x SSH_AUTH_SOCK $HOME/.ssh/agent.sock
        # need `ps -ww` to get non-truncated command for matching
        # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
        set -l ALREADY_RUNNING (ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $status)
        
        if test $ALREADY_RUNNING != "0"
            if test -S $SSH_AUTH_SOCK
                # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
                echo "removing previous socket..."
                rm $SSH_AUTH_SOCK
            end

            echo "Starting SSH-Agent relay..."
            # setsid to force new session to keep running
            # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
            set -lx cmd npiperelay.exe -ei -s //./pipe/openssh-ssh-agent
            setsid sh -c 'socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$cmd",nofork' >/dev/null 2>&1 &
        end
    end
    
    # asdf config
    source ~/.asdf/asdf.fish
end

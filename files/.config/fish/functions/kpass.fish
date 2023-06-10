function kpass --argument-names db --description "Launch keepass with given db open based on secret-tool password"
    fish -c "secret-tool lookup keepass $db | keepassxc --pw-stdin ~/secrets/$db.kdbx >/dev/null 2>&1; secret-tool lock --collection=\"keepass\"" >/dev/null 2>&1 &
    disown
end
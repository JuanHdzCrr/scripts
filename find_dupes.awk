BEGIN {
    OFS = "\t"
    md5_exec = "md5sum"
}

{
    size = $1
    file = substr($0, index($0, $2))
    file_size[size, ++file_size[size, "length"]] = file
    if (file_size[size, "length"] > 1 && size > 35)
        sizes[size]
}

END {
    for (size in sizes) {
        for (i = 1; i <= file_size[size, "length"]; i++) {
            file = file_size[size, i]
            cmd = md5_exec " \"" file "\""
            if ((cmd | getline line) > 0) {
                close(cmd)
                split(line, parts, " ")
                hash = parts[1]
                file_hash[hash, ++file_hash[hash, "length"]] = file
                if (file_hash[hash, "length"] > 1)
                    hashes[hash]

            } else {
                close(cmd)
            }
        }
    }

    for (hash in hashes) {
        print hash
        for (i = 1; i <= file_hash[hash, "length"]; i++)
            print OFS file_hash[hash, i]
    }
}

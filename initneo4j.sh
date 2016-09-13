#!/bin/bash -e

# Quick hack to run an automatic import of file(s) on startup, if this is a fresh instance.

if [ ! -d data/graph.db ];
then
    if [ -d /initneo4j/ ];
    then
        shopt -s nullglob
        # If import was failed we have to remove incorrectly created "data/graph.db" directory,
        # since Kubernetes restarts containers on failure and second start with non-empty
        # "data/graph.db" directory will be recognized as successful.
        trap 'echo "Import failed, removing the "data/graph.db" directory"; rm -rf "data/graph.db"' ERR
        for f in /initneo4j/*.sh;
        do
                chmod +x "$f"
                "$f"
        done
        for f in /initneo4j/*.neo4jshell;
        do
            ./bin/neo4j-shell -path data/graph.db -file ${f}
        done
        # Unset trap defined above
        trap - ERR
    fi
fi
exec /docker-entrypoint.sh $@

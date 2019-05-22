#!/bin/sh

release_ctl eval --mfa "DB.ReleaseTasks.generate_hash_ids/1" --argv -- "$@"

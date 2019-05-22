#!/bin/sh

release_ctl eval --mfa "DB.ReleaseTasks.migrate/1" --argv -- "$@"

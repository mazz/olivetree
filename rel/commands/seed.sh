#!/bin/sh

release_ctl eval --mfa "DB.ReleaseTasks.seed/1" --argv -- "$@"

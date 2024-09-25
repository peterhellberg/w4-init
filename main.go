package main

import (
	"bytes"
	"embed"
	"flag"
	"fmt"
	"io"
	"os"
)

//go:embed all:content
var content embed.FS

const (
	defaultHostname   = "play.c7.se"
	defaultServerPath = "/var/www/play.c7.se"
	defaultBackupPath = "/run/user/1000/gvfs/smb-share:server=diskstation.local,share=backups/Code/Fantasy/WASM-4"
)

type config struct {
	dir        string
	title      string
	hostname   string
	serverPath string
	backupPath string
}

func main() {
	if err := run(os.Args, os.Stderr); err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		os.Exit(1)
	}
}

func run(args []string, stderr io.Writer) error {
	var cfg config

	flags := flag.NewFlagSet(args[0], flag.ExitOnError)

	flags.SetOutput(stderr)

	flags.Usage = func() {
		format := "Usage: %s [OPTION]... DIRECTORY\n\nOptions:\n"

		fmt.Fprintf(flags.Output(), format, os.Args[0])

		flags.PrintDefaults()
	}

	flags.StringVar(&cfg.title, "title", "", "The title of the WASM-4 cart")
	flags.StringVar(&cfg.hostname, "hostname", defaultHostname, "The hostname to deploy the cart bundle to")
	flags.StringVar(&cfg.serverPath, "server-path", defaultServerPath, "The path on the server games should be uploaded to")
	flags.StringVar(&cfg.backupPath, "backup-path", defaultBackupPath, "The path to backup the cart bundle to")

	if err := flags.Parse(args[1:]); err != nil {
		return err
	}

	rest := flags.Args()

	// Require a directory name
	if len(rest) < 1 {
		return fmt.Errorf("no name given as the first argument")
	}

	cfg.dir = rest[0]

	if cfg.title == "" {
		cfg.title = cfg.dir
	}

	// Make sure that dir does not already exist
	if _, err := os.Stat(cfg.dir); !os.IsNotExist(err) {
		return fmt.Errorf("%q already exists", cfg.dir)
	}

	// Create the dir and dir/src
	if err := os.MkdirAll(cfg.dir+"/src", os.ModePerm); err != nil {
		return err
	}

	// Enter the new directory
	if err := os.Chdir(cfg.dir); err != nil {
		return err
	}

	entries, err := content.ReadDir("content")
	if err != nil {
		return err
	}

	for _, e := range entries {
		if !e.IsDir() {
			if err := writeFile(cfg, e.Name(), replacer); err != nil {
				return err
			}
		} else {
			if e.Name() == "src" {
				srcEntries, err := content.ReadDir("content/src")
				if err != nil {
					return err
				}

				for _, e := range srcEntries {
					if !e.IsDir() {
						if err := writeFile(cfg, "src/"+e.Name(), replacer); err != nil {
							return err
						}
					}
				}
			}
		}
	}

	return nil
}

func writeFile(cfg config, name string, dataFuncs ...dataFunc) error {
	data, err := content.ReadFile("content/" + name)
	if err != nil {
		return fmt.Errorf("writeFile: %w", err)
	}

	for i := range dataFuncs {
		data = dataFuncs[i](cfg, name, data)
	}

	return os.WriteFile(name, data, 0o644)
}

type dataFunc func(config, string, []byte) []byte

func replacer(cfg config, name string, data []byte) []byte {
	switch name {
	case "Makefile":
		data = replaceOne(data, `TITLE="w4-zig-cart"`, `TITLE="`+cfg.title+`"`)
		data = replaceOne(data, `NAME=w4-zig-cart`, `NAME=`+cfg.dir)
		data = replaceOne(data, `HOSTNAME=localhost`, `HOSTNAME=`+cfg.hostname)
		data = replaceOne(data, `SERVER_PATH=~/public_html`, `SERVER_PATH=`+cfg.serverPath)
		data = replaceOne(data, `BACKUP_PATH=/tmp/`, `BACKUP_PATH=`+cfg.backupPath)
		return data
	case "build.zig.zon", "README.md":
		return replaceOne(data, "w4-zig-cart", cfg.dir)
	default:
		return data
	}
}

func replaceOne(data []byte, old, new string) []byte {
	return bytes.Replace(data, []byte(old), []byte(new), 1)
}

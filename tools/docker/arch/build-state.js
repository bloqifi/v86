#!/usr/bin/env node
"use strict";

const path = require("path");

var fs = require("fs");
var V86 = require("./../../../build/libv86.js").V86;

const V86_ROOT = path.join(__dirname, "../../..");

var OUTPUT_FILE = path.join(V86_ROOT, "images/blockstate.bin");

process.stdin.setRawMode(true);
process.stdin.resume();
process.stdin.setEncoding("utf8");
process.stdin.on("data", handle_key);

var emulator = new V86({
    bios: { url: path.join(V86_ROOT, "/bios/seabios.bin") },
    vga_bios: { url: path.join(V86_ROOT, "/bios/vgabios.bin") },
    memory_size: 512 * 1024 * 1024,
    vga_memory_size: 8 * 1024 * 1024,
	bzimage_initrd_from_filesystem: true,
    filesystem: {
        basefs: {
            url: path.join(V86_ROOT, "/images/fs.json"),
        },
        baseurl: path.join(V86_ROOT, "/images/arch/"),
    },
	cmdline: "rw console=ttyS0,115200 apm=off root=host9p rootfstype=9p rootflags=trans=virtio,cache=loose mitigations=off audit=0 tsc=reliable nowatchdog",
    screen_dummy: true,
	network_relay_url: "<UNUSED>",
	disable_speaker: true,
	autostart: true,
});

console.log("Now booting, please stand by ...");

var boot_start = Date.now();
var serial_text = "";
let booted = false;

emulator.add_listener("serial0-output-char", function(c)
{
    process.stdout.write(c);

    serial_text += c;

    if(!booted && serial_text.endsWith("root@localhost:~# "))
    {
        console.error("\nBooted in %d", (Date.now() - boot_start) / 1000);
        booted = true;

        // sync and drop caches: Makes it safer to change the filesystem as fewer files are rendered
        emulator.serial0_send("sync;echo 3 >/proc/sys/vm/drop_caches\n");

        setTimeout(async function ()
		{
			const s = await emulator.save_state();

			fs.writeFile(OUTPUT_FILE, new Uint8Array(s), function(e)
				{
					if(e) throw e;
					console.error("Saved as " + OUTPUT_FILE);
					stop();
				});
		}, 10 * 1000);
    }
});

function handle_key(c)
{
    if(c === "\u0003")
    {
        // ctrl c
        stop();
    }
    else
    {
        emulator.serial0_send(c);
    }
}

function stop()
{
    emulator.stop();
    process.stdin.pause();
}
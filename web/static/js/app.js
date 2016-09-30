// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

import {Socket} from "phoenix";

$(() => {
    let socket = new Socket("/socket");
    socket.connect();

    let channel = socket.channel("uploads:lobby");
    channel
        .join()
        .receive("ok", () => console.log("Connected to socket"))
        .receive("error", () => console.log("Can't connect to socket"));

    let uploadsField = $(".uploads");

    channel.on("new:upload", msg => {
        if (uploadsField) {
            uploadsField.prepend(`<li>${msg.title} - ${msg.filename}</li>`);
        }
    });
});

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

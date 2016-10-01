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
            let template = `<div><h3>Id: ${msg.id}</h3>`;
            template += `<p>Short description: ${msg.description}`;
            template += `<p>Results visibility: ${msg.results_visibility}`;
            template += `<p>Instantiation: ${msg.job_instantiation}`;
            template += "<hr /></div>";
            uploadsField.prepend(template);
        }
    });
});

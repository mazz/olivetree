// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
// import css from "../css/app.css"
import css from "../css/app.scss"
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import "jquery";
import * as navbar from "./app/navbar.js";
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live")
liveSocket.connect()

function navbarScroll() {
  var navbar = document.getElementsByClassName("navbar is-fixed-top")[0];
  if (navbar && (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50)) {
    navbar.classList.remove("is-transparent");
  } else {
    navbar.classList.add("is-transparent");
  }
}

document.addEventListener("DOMContentLoaded", function () {
  window.onscroll = navbarScroll;
  navbar.initNavbar();
  navbarScroll();
});
// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import "./vue-hello-world"
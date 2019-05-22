import Vue from 'vue'
import VueApp from './VueApp'

Vue.config.productionTip = false

// const helloWorldContainer = document.querySelector("#hello-world-container")

// if (helloWorldContainer) {
//   new Vue({
//     el: "#hello-world-container",
//     data() {
//       return {
//         msg: "Hello World from Vue!"
//       }
//     }
//   });
// }  



/* eslint-disable no-new */
new Vue({
  el: '#myvueapp',
  components: { VueApp },
  template: '<VueApp/>'
})

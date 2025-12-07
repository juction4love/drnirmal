// worker.js
export default {
  async fetch(request) {
    return new Response("Hello from the Worker!");
  },
};

// worker.js

// This is the main handler for your Worker.
export default {
  async fetch(request, env, ctx) {
    
    // 1. --- DYNAMIC API LOGIC (Your Worker Code) ---
    const url = new URL(request.url);

    // EXAMPLE: If a user hits the /api/hello route, run dynamic code.
    if (url.pathname === '/api/hello' && request.method === 'GET') {
      return new Response("This is a dynamic API response!", {
        headers: { 'content-type': 'text/plain' },
      });
    }

    // 2. --- STATIC PAGE FALLBACK ---
    // If the request path does not match any dynamic logic above, 
    // we use the ASSETS binding (created by the --assets flag) 
    // to serve the static file (index.html, profile.png, etc.).

    // The 'env' object contains the ASSETS binding.
    // The fetch() method on the binding serves the static content.
    try {
      return env.ASSETS.fetch(request);
    } catch (e) {
      // If the static file isn't found, return a 404 error.
      return new Response('404 Page Not Found', { status: 404 });
    }
  },
};

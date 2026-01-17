async function updateCounter() {
  try {
    const response = await fetch(
      "https://zfin25pohuhhpuedk445ipoa2a0kcwpa.lambda-url.us-east-1.on.aws",
      {
        method: "GET",
        headers: {
          "Content-Type": "text/plain",
        },
        mode: "cors",
      }
    );

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result = await response.text();

    // DEBUG: Log the raw response
    console.log("Raw response:", result);
    console.log("Response length:", result.length);
    console.log("Response type:", typeof result);

    // Try different patterns
    const match1 = result.match(/\d+/); // Any number
    const match2 = result.match(/count[:\s]*(\d+)/i); // "count: 123" pattern
    const match3 = result.match(/: (\d+)/); // ": 123" pattern

    console.log("Match 1 (any number):", match1 ? match1[0] : "No match");
    console.log("Match 2 (count pattern):", match2 ? match2[1] : "No match");
    console.log("Match 3 (colon pattern):", match3 ? match3[1] : "No match");

    // Try to extract number
    let count = "0";
    if (match1) {
      count = match1[0];
    }

    // Update the display
    document.getElementById("visit-count").textContent = count;
    console.log("Final count displayed:", count);
  } catch (error) {
    console.error("Error fetching visit count:", error);
    document.getElementById("visit-count").textContent = "Error";
  }
}

// Run the function automatically when the page loads
window.addEventListener("DOMContentLoaded", updateCounter);

// Optional: Also update when user comes back to the page
document.addEventListener("visibilitychange", function () {
  if (!document.hidden) {
    updateCounter();
  }
});

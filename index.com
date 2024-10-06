<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Heartfelt Clock</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #ff7e5f, #feb47b); /* Warm gradient background */
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            font-family: 'Merriweather', serif; /* Classy serif font */
            color: #ffffff; /* White text for contrast */
        }

        .clock-container {
            position: relative;
            width: 60vmin; /* Responsive size */
            height: 60vmin; /* Responsive size */
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1); /* Slightly transparent clock background */
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4); /* Shadow for depth */
            backdrop-filter: blur(10px); /* Frosted glass effect */
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }

        .clock-face {
            position: relative;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 30%, rgba(255, 255, 255, 0) 70%);
            box-shadow: inset 0 0 20px rgba(0, 0, 0, 0.3);
        }

        .hand {
            position: absolute;
            bottom: 50%;
            left: 50%;
            transform-origin: bottom;
            transition: transform 0.5s ease-in-out;
        }

        .hour-hand {
            width: 6px;
            height: 25%;
            background-color: #ffcc00; /* Golden color for hour hand */
            border-radius: 10px;
        }

        .minute-hand {
            width: 4px;
            height: 35%;
            background-color: #ff6699; /* Pink color for minute hand */
            border-radius: 10px;
        }

        .second-hand {
            width: 2px;
            height: 40%;
            background-color: #00ccff; /* Cyan color for second hand */
            border-radius: 10px;
        }

        .elapsed-time {
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            text-align: center;
            font-size: 1.5rem;
            color: #ffffff;
            margin-top: 20px;
            width: 80%; /* Responsive width */
            max-width: 400px; /* Max width */
        }

        .quote-container {
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            text-align: center;
            font-size: 1.2rem;
            color: #ffffff;
            width: 80%; /* Responsive width */
            max-width: 400px; /* Max width */
            margin-top: 20px;
            transition: background 0.5s;
        }

        /* Hover effect for quotes */
        .quote-container:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        @media (max-width: 480px) {
            .elapsed-time {
                font-size: 1.2rem; /* Font size on mobile */
            }

            .quote-container {
                font-size: 1rem; /* Font size on mobile */
            }
        }
    </style>
</head>
<body>
    <div class="clock-container">
        <div class="clock-face">
            <div class="second-hand hand" id="second-hand"></div>
            <div class="minute-hand hand" id="minute-hand"></div>
            <div class="hour-hand hand" id="hour-hand"></div>
        </div>
    </div>
    <div class="elapsed-time" id="elapsed-time">Loading...</div>
    <div class="quote-container" id="love-message"></div>

    <script>
        const startTime = new Date('July 26, 2024 19:00:00').getTime();

        const quotes = [
            "I’m always within you Avani..",
            "I’ll always be there to protect you…",
            "You’re mine and you’ll always be mine.",
            "Love is not love which alters when it alteration finds.",
            "I carry your heart with me (I carry it in my heart).",
            "In vain have I struggled. It will not do. My feelings will not be repressed.",
            "You know you’re in love when you can’t fall asleep because reality is finally better than your dreams.",
            "Whatever our souls are made of.",
            "I have waited for this opportunity for more than half a century, to repeat to you once again my vow of eternal fidelity and everlasting love."
        ];

        function updateClock() {
            const now = new Date().getTime();
            const elapsed = now - startTime;

            const days = Math.floor(elapsed / (1000 * 60 * 60 * 24));
            const hours = Math.floor((elapsed % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((elapsed % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((elapsed % (1000 * 60)) / 1000);

            const timeString = `${days} days, ${hours} hours, ${minutes} minutes, and ${seconds} seconds`;
            document.getElementById('elapsed-time').innerHTML = timeString;

            // Update clock hands
            const secondHand = document.getElementById('second-hand');
            const minuteHand = document.getElementById('minute-hand');
            const hourHand = document.getElementById('hour-hand');

            const totalSeconds = Math.floor((now - startTime) / 1000);
            const secondsDeg = ((totalSeconds % 60) / 60) * 360;
            const minutesDeg = ((Math.floor(totalSeconds / 60) % 60) / 60) * 360;
            const hoursDeg = ((Math.floor(totalSeconds / 3600) % 12) / 12) * 360;

            secondHand.style.transform = `translate(-50%, 0) rotate(${secondsDeg}deg)`;
            minuteHand.style.transform = `translate(-50%, 0) rotate(${minutesDeg}deg)`;
            hourHand.style.transform = `translate(-50%, 0) rotate(${hoursDeg}deg)`;

            // Update the quote every 10 seconds
            const quoteIndex = Math.floor((totalSeconds / 10) % quotes.length);
            document.getElementById('love-message').innerHTML = quotes[quoteIndex];
        }

        setInterval(updateClock, 1000);
        updateClock();  // Initial call to set clock immediately
    </script>
</body>
</html>

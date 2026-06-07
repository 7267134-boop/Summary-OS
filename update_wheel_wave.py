# -*- coding: utf-8 -*-
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    html = f.read()

# Define the new initWheel content (includes defs & linearGradient programmatic creation, plus animated segments)
new_init_wheel = """        function initWheel() {
            svg.innerHTML = ''; 
            
            // 0. Create SVG defs and linear gradient for the dynamic, moving rainbow wave
            const defs = document.createElementNS("http://www.w3.org/2000/svg", "defs");
            const grad = document.createElementNS("http://www.w3.org/2000/svg", "linearGradient");
            grad.setAttribute("id", "rainbow-grad");
            grad.setAttribute("x1", "160");
            grad.setAttribute("y1", "160");
            grad.setAttribute("x2", "640");
            grad.setAttribute("y2", "640");
            grad.setAttribute("gradientUnits", "userSpaceOnUse");
            
            // Colorful stops with a bright glowing highlight (wave peak) at the center
            const stops = [
                { offset: "0%", color: "#fb7185" },
                { offset: "12%", color: "#fb923c" },
                { offset: "24%", color: "#facc15" },
                { offset: "36%", color: "#a3e635" },
                { offset: "48%", color: "#34d399" },
                { offset: "50%", color: "#ffffff" }, // Glow wave peak
                { offset: "52%", color: "#2dd4bf" },
                { offset: "64%", color: "#38bdf8" },
                { offset: "76%", color: "#60a5fa" },
                { offset: "88%", color: "#818cf8" },
                { offset: "100%", color: "#c084fc" }
            ];
            
            stops.forEach(s => {
                const stop = document.createElementNS("http://www.w3.org/2000/svg", "stop");
                stop.setAttribute("offset", s.offset);
                stop.setAttribute("stop-color", s.color);
                grad.appendChild(stop);
            });
            defs.appendChild(grad);
            svg.appendChild(defs);
            
            // 1. Draw glassy base track
            // Inner track border
            const innerBorder = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            innerBorder.setAttribute("cx", CX);
            innerBorder.setAttribute("cy", CY);
            innerBorder.setAttribute("r", RADIUS - 60);
            innerBorder.setAttribute("fill", "none");
            innerBorder.setAttribute("stroke", "rgba(255, 255, 255, 0.35)");
            innerBorder.setAttribute("stroke-width", "1.5");
            svg.appendChild(innerBorder);

            // Outer track border
            const outerBorder = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            outerBorder.setAttribute("cx", CX);
            outerBorder.setAttribute("cy", CY);
            outerBorder.setAttribute("r", RADIUS + 60);
            outerBorder.setAttribute("fill", "none");
            outerBorder.setAttribute("stroke", "rgba(255, 255, 255, 0.35)");
            outerBorder.setAttribute("stroke-width", "1.5");
            svg.appendChild(outerBorder);

            // Main track glassy filling
            const track = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            track.setAttribute("cx", CX);
            track.setAttribute("cy", CY);
            track.setAttribute("r", RADIUS);
            track.setAttribute("fill", "none");
            track.setAttribute("stroke", "rgba(255, 255, 255, 0.12)");
            track.setAttribute("stroke-width", "120");
            svg.appendChild(track);

            // 2. Draw Progress Segments (with class for wave animation and staggered delay)
            for (let i = 0; i < SLICES; i++) {
                const startAngle = -Math.PI / 2 + (i * ANGLE_STEP);
                const endAngle = startAngle + ANGLE_STEP;
                
                const startP = polarToCartesian(CX, CY, RADIUS, startAngle);
                const endP = polarToCartesian(CX, CY, RADIUS, endAngle);
                
                const d = [
                    "M", startP.x, startP.y,
                    "A", RADIUS, RADIUS, 0, 0, 1, endP.x, endP.y
                ].join(" ");

                const segment = document.createElementNS("http://www.w3.org/2000/svg", "path");
                segment.setAttribute("d", d);
                segment.setAttribute("fill", "none");
                segment.setAttribute("stroke-width", "120");
                segment.setAttribute("stroke-linecap", "butt");
                segment.classList.add("progress-segment-anim");
                segment.style.animationDelay = `${i * 0.35}s`; // Staggered delays create the traveling wave effect
                progressSegments.push(segment);
                svg.appendChild(segment);
            }

            // 3. Draw nodes (grouped in <g> with scale-on-hover effect and huge clickable areas)
            chaptersData.forEach((chapter, index) => {
                const angle = -Math.PI / 2 + (index * ANGLE_STEP);
                const pos = polarToCartesian(CX, CY, RADIUS, angle);
                
                // Group element to hold circle, text, and large target
                const nodeGroup = document.createElementNS("http://www.w3.org/2000/svg", "g");
                nodeGroup.setAttribute("class", "node-group cursor-pointer outline-none");
                nodeGroup.style.transformOrigin = `${pos.x}px ${pos.y}px`;
                
                // Large transparent hit circle for easy clicking/hovering anywhere in the neighborhood
                const hoverTarget = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                hoverTarget.setAttribute("cx", pos.x);
                hoverTarget.setAttribute("cy", pos.y);
                hoverTarget.setAttribute("r", "45");
                hoverTarget.setAttribute("fill", "transparent");
                nodeGroup.appendChild(hoverTarget);
                
                const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                circle.setAttribute("cx", pos.x);
                circle.setAttribute("cy", pos.y);
                circle.style.transition = "all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)";
                nodeCircles.push(circle);
                nodeGroup.appendChild(circle);
                
                const textNum = document.createElementNS("http://www.w3.org/2000/svg", "text");
                textNum.setAttribute("x", pos.x);
                textNum.setAttribute("y", pos.y);
                textNum.setAttribute("text-anchor", "middle");
                textNum.setAttribute("dominant-baseline", "central");
                textNum.setAttribute("dy", "0.1em");
                textNum.style.transition = "all 0.3s ease";
                textNum.textContent = chapter.id;
                nodeTexts.push(textNum);
                nodeGroup.appendChild(textNum);
                
                // Add click and hover events to the entire group
                const color = rainbowColors[index];
                nodeGroup.addEventListener('mouseenter', () => updateCenter(chapter.id, color));
                nodeGroup.addEventListener('click', () => { window.location.href = chapter.link; });
                nodeGroup.addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    updateCenter(chapter.id, color);
                });
                nodeGroup.addEventListener('touchend', (e) => {
                    if (activeChapterId === chapter.id) {
                        window.location.href = chapter.link;
                    }
                });

                svg.appendChild(nodeGroup);
            });

            // 4. Draw Hitboxes (Thick Arcs covering the entire segment of 120 width)
            chaptersData.forEach((chapter, index) => {
                const startAngle = -Math.PI / 2 + (index - 0.5) * ANGLE_STEP;
                const endAngle = -Math.PI / 2 + (index + 0.5) * ANGLE_STEP;

                const startP = polarToCartesian(CX, CY, RADIUS, startAngle);
                const endP = polarToCartesian(CX, CY, RADIUS, endAngle);
                
                const largeArcFlag = ((endAngle - startAngle) <= Math.PI) ? "0" : "1";
                
                const d = [
                    "M", startP.x, startP.y,
                    "A", RADIUS, RADIUS, 0, largeArcFlag, 1, endP.x, endP.y
                ].join(" ");

                const hitbox = document.createElementNS("http://www.w3.org/2000/svg", "path");
                hitbox.setAttribute("d", d);
                hitbox.setAttribute("fill", "none");
                hitbox.setAttribute("stroke", "transparent");
                hitbox.setAttribute("stroke-width", "120"); // Cover the full track width
                hitbox.setAttribute("class", "cursor-pointer outline-none");
                
                hitbox.addEventListener('mouseenter', () => updateCenter(chapter.id, rainbowColors[index]));
                hitbox.addEventListener('click', () => { window.location.href = chapter.link; });
                hitbox.addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    updateCenter(chapter.id, rainbowColors[index]);
                });
                hitbox.addEventListener('touchend', (e) => {
                    if (activeChapterId === chapter.id) {
                        window.location.href = chapter.link;
                    }
                });

                svg.appendChild(hitbox);
            });
        }"""

# Define the new updateWheelState content (activates animated wave classes on active segments)
new_update_wheel_state = """        function updateWheelState() {
            const activeIndex = chaptersData.findIndex(c => c.id === activeChapterId);
            const activeColor = rainbowColors[activeIndex];

            // Update Progress Segments (activate dynamic wave animation)
            progressSegments.forEach((segment, index) => {
                if (index < activeIndex) {
                    segment.setAttribute("stroke", "url(#rainbow-grad)"); // Shifting rainbow gradient
                    segment.classList.add("active-wave");
                } else {
                    segment.classList.remove("active-wave");
                }
            });

            // Update Nodes (frosted glass appearance matching the track)
            chaptersData.forEach((chapter, index) => {
                const color = rainbowColors[index];
                const isActive = chapter.id === activeChapterId;
                const isPassed = index <= activeIndex;
                
                const circle = nodeCircles[index];
                if (isActive) {
                    circle.setAttribute("r", "28");
                    circle.setAttribute("fill", activeColor);
                    circle.setAttribute("stroke", "#ffffff");
                    circle.setAttribute("stroke-width", "5");
                } else if (isPassed) {
                    circle.setAttribute("r", "20");
                    circle.setAttribute("fill", "#ffffff");
                    circle.setAttribute("stroke", color);
                    circle.setAttribute("stroke-width", "4");
                } else {
                    circle.setAttribute("r", "20");
                    circle.setAttribute("fill", "rgba(255, 255, 255, 0.75)");
                    circle.setAttribute("stroke", "rgba(255, 255, 255, 0.45)");
                    circle.setAttribute("stroke-width", "2");
                }
                
                const textNum = nodeTexts[index];
                textNum.setAttribute("class", `text-${isActive ? '2xl' : 'lg'} font-black pointer-events-none transition-colors duration-300`);
                textNum.setAttribute("fill", isActive ? "#ffffff" : (isPassed ? "#0f172a" : "#475569"));
            });
        }"""

# Search and replace function initWheel
start_marker = "        function initWheel() {"
end_marker = "        function updateWheelState() {"

init_wheel_start = html.find(start_marker)
update_wheel_start = html.find(end_marker)

if init_wheel_start != -1 and update_wheel_start != -1:
    part1 = html[:init_wheel_start]
    part2 = html[update_wheel_start:]
    html = part1 + new_init_wheel + "\n\n" + part2
    print("  -> Replaced initWheel in HTML content")
else:
    print("ERROR: Could not find initWheel or updateWheelState start markers.")
    exit(1)

# Now find function updateWheelState() up to function updateCenter()
update_wheel_start = html.find(end_marker)
update_center_start = html.find("        function updateCenter(")

if update_wheel_start != -1 and update_center_start != -1:
    part1 = html[:update_wheel_start]
    part2 = html[update_center_start:]
    html = part1 + new_update_wheel_state + "\n\n" + part2
    print("  -> Replaced updateWheelState in HTML content")
else:
    print("ERROR: Could not find updateWheelState or updateCenter start markers.")
    exit(1)

# 4. Replace the DOMContentLoaded block where nodeStyle was created to inject the wave animations & gradient rotation
js_inject_style = """            // Inject dynamic style for node groups, rotating gradient, and wave pulse effects
            const nodeStyle = document.createElement('style');
            nodeStyle.textContent = `
                .node-group {
                    transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                }
                .node-group:hover {
                    transform: scale(1.15);
                }
                @keyframes rotateGrad {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
                #rainbow-grad {
                    transform-origin: 400px 400px;
                    animation: rotateGrad 12s linear infinite;
                }
                @keyframes pulseWave {
                    0%, 100% {
                        stroke-width: 120;
                        opacity: 0.65;
                    }
                    50% {
                        stroke-width: 126;
                        opacity: 0.85;
                    }
                }
                .progress-segment-anim {
                    display: none;
                }
                .progress-segment-anim.active-wave {
                    display: block;
                    animation: pulseWave 3.5s ease-in-out infinite;
                }
            `;
            document.head.appendChild(nodeStyle);"""

# Replace lines containing the old nodeStyle injection
dom_loaded_marker = "        document.addEventListener('DOMContentLoaded', () => {"
init_wheel_call_marker = "            initWheel();"

dom_loaded_idx = html.find(dom_loaded_marker)
init_wheel_idx = html.find(init_wheel_call_marker)

if dom_loaded_idx != -1 and init_wheel_idx != -1:
    part1 = html[:dom_loaded_idx + len(dom_loaded_marker)]
    part2 = html[init_wheel_idx:]
    html = part1 + "\n" + js_inject_style + "\n" + part2
    print("  -> Injected comprehensive wave, gradient, and group hover styles")
else:
    print("ERROR: Could not find DOMContentLoaded structure to replace styles.")
    exit(1)

print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(html)

print("=== Done! ===")
print("  - Implemented dynamic gradient stop rotation (#rainbow-grad with rotateGrad animation)")
print("  - Added staggered wave animation pulseWave for physical waving thickness/glow effect")
print("  - Preserved large click targets and hover node scales")

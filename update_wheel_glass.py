# -*- coding: utf-8 -*-
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    html = f.read()

# Define the new initWheel content
new_init_wheel = """        function initWheel() {
            svg.innerHTML = ''; 
            
            // 1. Draw glassy base track
            // Inner track border
            const innerBorder = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            innerBorder.setAttribute("cx", CX);
            innerBorder.setAttribute("cy", CY);
            innerBorder.setAttribute("r", RADIUS - 24);
            innerBorder.setAttribute("fill", "none");
            innerBorder.setAttribute("stroke", "rgba(255, 255, 255, 0.35)");
            innerBorder.setAttribute("stroke-width", "1.5");
            svg.appendChild(innerBorder);

            // Outer track border
            const outerBorder = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            outerBorder.setAttribute("cx", CX);
            outerBorder.setAttribute("cy", CY);
            outerBorder.setAttribute("r", RADIUS + 24);
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
            track.setAttribute("stroke-width", "48");
            svg.appendChild(track);

            // 2. Draw Progress Segments (Thick glassy segments matching the track)
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
                segment.setAttribute("stroke-width", "48");
                segment.style.transition = "stroke 0.4s ease-in-out, opacity 0.4s ease-in-out";
                segment.style.opacity = "0";
                progressSegments.push(segment);
                svg.appendChild(segment);
            }

            // 3. Draw nodes
            chaptersData.forEach((chapter, index) => {
                const angle = -Math.PI / 2 + (index * ANGLE_STEP);
                const pos = polarToCartesian(CX, CY, RADIUS, angle);
                
                const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                circle.setAttribute("cx", pos.x);
                circle.setAttribute("cy", pos.y);
                circle.style.transition = "all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)";
                nodeCircles.push(circle);
                svg.appendChild(circle);
                
                const textNum = document.createElementNS("http://www.w3.org/2000/svg", "text");
                textNum.setAttribute("x", pos.x);
                textNum.setAttribute("y", pos.y);
                textNum.setAttribute("text-anchor", "middle");
                textNum.setAttribute("dominant-baseline", "central");
                textNum.setAttribute("dy", "0.1em");
                textNum.textContent = chapter.id;
                nodeTexts.push(textNum);
                svg.appendChild(textNum);
            });

            // 4. Draw Hitboxes (Thick Arcs covering the entire segment)
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
                hitbox.setAttribute("stroke-width", "80");
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

# Define the new updateWheelState content
new_update_wheel_state = """        function updateWheelState() {
            const activeIndex = chaptersData.findIndex(c => c.id === activeChapterId);
            const activeColor = rainbowColors[activeIndex];

            // Update Progress Segments (wide glassy coloring)
            progressSegments.forEach((segment, index) => {
                if (index < activeIndex) {
                    segment.setAttribute("stroke", rainbowColors[(index + 1) % rainbowColors.length]);
                    segment.style.opacity = "0.7"; // Glassy translucent rainbow color
                } else {
                    segment.style.opacity = "0";
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
start_marker = "function initWheel() {"
end_marker = "        function updateWheelState() {"

# Let's find function initWheel() up to updateWheelState()
init_wheel_start = html.find(start_marker)
update_wheel_start = html.find(end_marker)

if init_wheel_start != -1 and update_wheel_start != -1:
    print("Found function initWheel and updateWheelState markers in HTML.")
    
    # Replace initWheel
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

print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(html)

print("=== Done! ===")
print("  - Base track converted to wide frosted glass tube layout")
print("  - Progress segments changed to wide glassy segments with 0.7 opacity")
print("  - Node circles redesigned to match the frosted glass theme beautifully")

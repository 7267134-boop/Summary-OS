import re
import subprocess
import os

def check_html_js_runtime(filename):
    print(f"\n=== Running runtime check on {filename} ===")
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract the main script block
    scripts = re.findall(r'<script\b[^>]*>(.*?)</script>', content, re.DOTALL)
    main_script = ""
    for script in scripts:
        script = script.strip()
        if not script or 'MathJax' in script or 'tailwind.config' in script:
            continue
        main_script = script
        break
        
    if not main_script:
        print("No main script block found!")
        return

    mock_env = """
    // Basic DOM Mocking
    const domListeners = {};
    
    function createMockElement(id = '') {
        return {
            id: id,
            classList: {
                add: function() { return this; },
                remove: function() { return this; },
                contains: () => false,
                toggle: () => false
            },
            appendChild: (el) => {},
            innerHTML: "",
            style: {},
            children: [],
            getAttribute: () => '',
            setAttribute: () => {},
            addEventListener: (event, cb) => {},
            removeEventListener: () => {},
            textContent: ''
        };
    }
    
    global.window = {
        location: { hash: '' },
        addEventListener: (event, cb) => {
            domListeners[event] = cb;
        },
        scrollTo: () => {},
        innerWidth: 1024,
        triggerGangSim: () => {},
        setFlashcardMode: () => {},
        filterFlashcards: () => {},
        toggleFlashcard: () => {},
        resetFlashcards: () => {},
        showTab: () => {},
        toggleSidebar: () => {},
        toggleAnswer: () => {},
        toggleCoherenceMesi: () => {},
        resetCoherenceSim: () => {},
        coherenceRead: () => {},
        coherenceWrite: () => {},
        setMsMode: () => {},
        resetMsSim: () => {},
        triggerMsWorkload: () => {},
        busAcquireLock: () => {},
        busTriggerSpinlock: () => {},
        busReleaseLock: () => {},
        resetBusSim: () => {},
        affinityDragStart: () => {},
        affinityAllowDrop: () => {},
        affinityDrop: () => {},
        resetAffinityGame: () => {},
        setGangMode: () => {},
        resetGangSim: () => {},
        ch6_setFlashcardMode: () => {},
        ch6_resetFlashcards: () => {}
    };
    
    global.document = {
        addEventListener: (event, cb) => {
            domListeners[event] = cb;
        },
        getElementById: (id) => {
            console.log("Mock getElementById called for: " + id);
            return createMockElement(id);
        },
        querySelectorAll: (selector) => {
            console.log("Mock querySelectorAll called for: " + selector);
            const mockEl1 = createMockElement('el1');
            const mockEl2 = createMockElement('el2');
            return [mockEl1, mockEl2];
        },
        querySelector: (selector) => {
            console.log("Mock querySelector called for: " + selector);
            return createMockElement();
        },
        createElement: (tag) => {
            return createMockElement();
        },
        body: createMockElement('body')
    };
    
    global.localStorage = {
        getItem: (key) => null,
        setItem: (key, val) => {}
    };
    
    try {
        (() => {
            {SCRIPT_CONTENT}
        })();
        
        console.log("Triggering DOMContentLoaded...");
        if (domListeners['DOMContentLoaded']) {
            domListeners['DOMContentLoaded']();
        }
        console.log("Triggering load...");
        if (domListeners['load']) {
            domListeners['load']();
        }
        console.log("SUCCESS: Script ran to completion without errors!");
    } catch (err) {
        console.error("RUNTIME ERROR:", err);
        process.exit(1);
    }
    """
    
    runnable_content = mock_env.replace("{SCRIPT_CONTENT}", main_script)
    
    temp_file = "temp_runtime_check.js"
    with open(temp_file, 'w', encoding='utf-8') as tf:
        tf.write(runnable_content)
        
    res = subprocess.run(['node', temp_file], capture_output=True)
    stdout = res.stdout.decode('utf-8', errors='replace')
    stderr = res.stderr.decode('utf-8', errors='replace')
    
    print("STDOUT:")
    print(stdout)
    if stderr:
        print("STDERR:")
        print(stderr)
        
    if os.path.exists(temp_file):
        os.remove(temp_file)

check_html_js_runtime("chapter_6.html")
check_html_js_runtime("chapter_7.html")
check_html_js_runtime("chapter_8.html")

/**
 * ShinyX Loader Animation
 */

(function() {
    'use strict';
    
    // Create loader HTML
    const loaderHTML = `
        <div id="shinyx-loader">
            <div class="loader-content">
                <div class="logo-text animate__animated animate__fadeInDown">
                    <span class="shiny">Shiny</span><span class="x">X</span>
                </div>
                
                <div class="spinner-container">
                    <div class="spinner"></div>
                    <div class="spinner-inner"></div>
                    <div class="orbit">
                        <div class="orbit-dot"></div>
                        <div class="orbit-dot"></div>
                        <div class="orbit-dot"></div>
                        <div class="orbit-dot"></div>
                    </div>
                </div>
                
                <div class="loading-text">Loading...</div>
            </div>
        </div>
    `;
    
    // Create styles
    const loaderStyles = `
        <style id="shinyx-loader-styles">
            #shinyx-loader {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #000000 0%, #0a0a0a 50%, #000000 100%);
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                z-index: 9999;
                transition: opacity 0.5s ease-out, visibility 0.5s ease-out;
            }

            #shinyx-loader.fade-out {
                opacity: 0;
                visibility: hidden;
            }

            #shinyx-loader .loader-content {
                text-align: center;
                position: relative;
            }

            #shinyx-loader .logo-text {
                font-size: 72px;
                font-weight: bold;
                margin-bottom: 30px;
                letter-spacing: 2px;
            }

            #shinyx-loader .logo-text .shiny {
                color: #3b82f6;
                display: inline-block;
                animation: shinyx-glow 2s ease-in-out infinite;
            }

            #shinyx-loader .logo-text .x {
                color: #ffffff;
                display: inline-block;
                animation: shinyx-pulse 2s ease-in-out infinite;
            }

            @keyframes shinyx-glow {
                0%, 100% {
                    text-shadow: 0 0 10px #3b82f6, 0 0 20px #3b82f6, 0 0 30px #3b82f6;
                }
                50% {
                    text-shadow: 0 0 20px #3b82f6, 0 0 30px #3b82f6, 0 0 40px #3b82f6, 0 0 50px #3b82f6;
                }
            }

            @keyframes shinyx-pulse {
                0%, 100% {
                    transform: scale(1);
                    opacity: 1;
                }
                50% {
                    transform: scale(1.1);
                    opacity: 0.8;
                }
            }

            #shinyx-loader .spinner-container {
                position: relative;
                width: 120px;
                height: 120px;
                margin: 0 auto;
            }

            #shinyx-loader .spinner {
                width: 120px;
                height: 120px;
                border: 4px solid rgba(59, 130, 246, 0.1);
                border-top: 4px solid #3b82f6;
                border-radius: 50%;
                animation: shinyx-spin 1s linear infinite;
            }

            #shinyx-loader .spinner-inner {
                position: absolute;
                top: 10px;
                left: 10px;
                width: 100px;
                height: 100px;
                border: 4px solid rgba(255, 255, 255, 0.1);
                border-bottom: 4px solid #ffffff;
                border-radius: 50%;
                animation: shinyx-spin 1.5s linear infinite reverse;
            }

            @keyframes shinyx-spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            #shinyx-loader .orbit {
                position: absolute;
                top: 50%;
                left: 50%;
                width: 140px;
                height: 140px;
                margin: -70px 0 0 -70px;
            }

            #shinyx-loader .orbit-dot {
                position: absolute;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #3b82f6;
                box-shadow: 0 0 10px #3b82f6;
            }

            #shinyx-loader .orbit-dot:nth-child(1) {
                top: 0;
                left: 50%;
                margin-left: -6px;
                animation: shinyx-orbit-fade 2s ease-in-out infinite;
            }

            #shinyx-loader .orbit-dot:nth-child(2) {
                top: 50%;
                right: 0;
                margin-top: -6px;
                animation: shinyx-orbit-fade 2s ease-in-out infinite 0.5s;
            }

            #shinyx-loader .orbit-dot:nth-child(3) {
                bottom: 0;
                left: 50%;
                margin-left: -6px;
                animation: shinyx-orbit-fade 2s ease-in-out infinite 1s;
            }

            #shinyx-loader .orbit-dot:nth-child(4) {
                top: 50%;
                left: 0;
                margin-top: -6px;
                animation: shinyx-orbit-fade 2s ease-in-out infinite 1.5s;
            }

            @keyframes shinyx-orbit-fade {
                0%, 100% { opacity: 0.3; transform: scale(0.8); }
                50% { opacity: 1; transform: scale(1.2); }
            }

            #shinyx-loader .loading-text {
                color: #666;
                font-size: 14px;
                margin-top: 30px;
                letter-spacing: 3px;
                text-transform: uppercase;
                animation: shinyx-fade 1.5s ease-in-out infinite;
            }

            @keyframes shinyx-fade {
                0%, 100% { opacity: 0.3; }
                50% { opacity: 1; }
            }

            /* Mobile responsive */
            @media (max-width: 768px) {
                #shinyx-loader .logo-text {
                    font-size: 48px;
                }
                
                #shinyx-loader .spinner-container {
                    width: 80px;
                    height: 80px;
                }
                
                #shinyx-loader .spinner {
                    width: 80px;
                    height: 80px;
                }
                
                #shinyx-loader .spinner-inner {
                    width: 60px;
                    height: 60px;
                }
                
                #shinyx-loader .orbit {
                    width: 100px;
                    height: 100px;
                    margin: -50px 0 0 -50px;
                }
            }
        </style>
    `;
    
    // Initialize loader
    function initShinyXLoader() {
        // Inject styles
        document.head.insertAdjacentHTML('beforeend', loaderStyles);
        
        // Inject loader HTML
        document.body.insertAdjacentHTML('afterbegin', loaderHTML);
        
        // Wait for Shiny to be ready or timeout after 3 seconds
        let shinyCheckCount = 0;
        const maxChecks = 30; // 3 seconds (30 * 100ms)
        
        const checkShinyReady = setInterval(() => {
            shinyCheckCount++;
            
            // Check if Shiny is connected or max time elapsed
            const isShinyConnected = typeof Shiny !== 'undefined' && 
                                     Shiny.shinyapp && 
                                     Shiny.shinyapp.isConnected();
            
            if (isShinyConnected || shinyCheckCount >= maxChecks) {
                clearInterval(checkShinyReady);
                hideLoader();
            }
        }, 100);
        
        // Fallback: hide loader after 3 seconds no matter what
        setTimeout(() => {
            clearInterval(checkShinyReady);
            hideLoader();
        }, 3000);
    }
    
    // Hide loader with fade out animation
    function hideLoader() {
        const loader = document.getElementById('shinyx-loader');
        if (loader) {
            loader.classList.add('fade-out');
            
            // Remove from DOM after animation completes
            setTimeout(() => {
                loader.remove();
                // Remove styles
                const styles = document.getElementById('shinyx-loader-styles');
                if (styles) styles.remove();
            }, 500);
        }
    }
    
    // Start when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initShinyXLoader);
    } else {
        initShinyXLoader();
    }
    
    // Expose method to manually hide loader
    window.hideShinyXLoader = hideLoader;
})();
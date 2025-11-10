<META http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<html>
<head>
    <title>webMethods Dashboard - Menu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            margin: 0;
        }
       
        header {
            background-color: #1776BF;
            color: white;
            font-family: Tahoma, Verdana, Arial, Geneva, Helvetica, sans-serif;
            font-size: 16px;
            font-weight: bold;
            padding: 10px 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #0F5CCF;
        }

        #hostInfo {
            font-weight: bold;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: #D1E4F4; /* lighter blue for contrast */
        }

        nav {
            /* Align nav buttons right */
            display: flex;
            gap: 12px;
        }

        nav a {
            background-color: #1776BF; /* Slightly darker blue button */
            color: white;
            text-decoration: none;
            padding: 6px 14px;
            border-radius: 5px;
            font-weight: normal;
            font-size: 13px;
            box-shadow: 0 2px 4px rgb(0 0 0 / 0.2);
            transition: background-color 0.3s ease;
        }

        nav a:hover {
            background-color: #14629F;
        }
		
		  nav a.active {
		  background-color: #14629F;  /* darker blue or your preferred highlight color */
		  color: #FFF;                /* white text */
		  font-weight: bold;
		}
        /* Container to hold iframe and overlay */
        #iframeContainer {
            position: relative;
            width: 100%;
            height: 600px; /* Match your iframe height */
            border: none;
            margin: 0;
        }

        iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        /* Overlay div to block Admin tab */
		
		#overlayBlocker {
    display: none; /* Initially hidden */
    position: absolute;
    top: 0px;    
    left: 0px;  
    width: 100%; 
    height: 100%; 
    background-color: rgba(255, 255, 255, 0.25); 
    z-index: 10;
    cursor: not-allowed;
    border-radius: 4px;
    box-shadow: 0 0 10px rgba(0,0,0,0.2);
}

#pointerIndicator {
    position: fixed;
    width: 20px;
    height: 20px;
    background: red;
    border-radius: 50%;
    pointer-events: none; /* so it doesn’t block mouse */
    transition: transform 0.3s ease;
    z-index: 99999;
    transform: translate(-50%, -50%);
    display: none;
  }
  #spinnerOverlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(255, 255, 255, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 99999;
  }

  /* Spinner styling */
  .spinner {
    width: 60px;
    height: 60px;
    border: 8px solid #ccc;
    border-top: 8px solid #1776BF; /* your brand blue */
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

    </style>
</head>
<body>

<header>
  <nav>
    %invoke systemmonitoring.query:getCurrentUser%
    <a href="/SYSTEMMONITORING/scheduler.dsp" target="contentFrame">Scheduler</a>
    <a href="/SYSTEMMONITORING/server-threads-new.dsp" target="contentFrame">Threads</a>
    <a href="/SYSTEMMONITORING/log-error-recent.dsp" target="contentFrame">Logs</a>
    <a id="monitorLink" href="#" target="contentFrame">Monitor</a>
  </nav>
  <div id="hostInfo">
    %value username%&nbsp;<span id="hostDisplay">Loading...</span>
  </div>
</header>
<div id="spinnerOverlay">
  <div class="spinner"></div>
</div>
<div id="iframeContainer">
    <iframe name="contentFrame" src=""></iframe>
    <div id="overlayBlocker" title="Access to Administration tab is blocked"></div>
</div>

  <script>
	document.addEventListener('DOMContentLoaded', () => {
  const baseUrl = window.location.origin;
  const monitorUrl = baseUrl + "/WmAdmin/#/monitoring/services";
  const monitorLink = document.getElementById('monitorLink');
  const overlay = document.getElementById('overlayBlocker');
  const navLinks = document.querySelectorAll('nav a');
const spinnerOverlay = document.getElementById('spinnerOverlay');
  monitorLink.href = monitorUrl;
  document.getElementById('hostDisplay').textContent = 'Monitoring ' + window.location.hostname;


  monitorLink.addEventListener('click', () => {
        overlay.style.display = 'block';
		spinnerOverlay.style.display = 'flex';
		setActiveButton(monitorLink);
        setTimeout(() => {      
			overlay.style.display = 'block';
			overlay.style.pointerEvents = 'auto';		
            waitForIframeAndElements(clickMonitorThenHideAdmin);
        }, 5000);
		
    });

  navLinks.forEach(link => {
    if (link !== monitorLink) {
      link.addEventListener('click', () => {
        overlay.style.display = 'none';
		overlay.style.pointerEvents = 'auto';
		spinnerOverlay.style.display = 'none';
		setActiveButton(link);
      });
    }
  });
  monitorLink.click();
  setActiveButton(monitorLink);
});
	function setActiveButton(button) {
  const navLinks = document.querySelectorAll('nav a');
  navLinks.forEach(link => link.classList.remove('active'));
  button.classList.add('active');
}
  function waitForIframeAndElements(callback) {
    const checkInterval = setInterval(() => {
        const iframe = document.querySelector('iframe[name="contentFrame"]');
        if (!iframe) return;

        const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
        if (!iframeDoc) return;
		spinnerOverlay.style.display = 'none';
        const monitorEl = iframeDoc.querySelector('#monitor-link, a[href*="monitoring/services"]');
        const serverEl = iframeDoc.getElementById('server-home-link');
        const logoAnchor = iframeDoc.querySelector('a.navbar-brand.welcome-page-logo');

        if (monitorEl && serverEl && logoAnchor) {
            clearInterval(checkInterval);
            callback(iframeDoc, monitorEl, serverEl, logoAnchor);
        }
    }, 500);
}

function clickMonitorThenHideAdmin(iframeDoc, monitorEl, serverEl, logoAnchor) {
    // Disable logo click
    logoAnchor.removeAttribute('href');
    logoAnchor.style.pointerEvents = 'none';
    console.log('Disabled click on logo inside iframe');
    // Function to hide Admin link
    const hideAdmin = () => {
        if (serverEl && serverEl.style.display !== 'none') {
            serverEl.style.display = 'none';
            console.log('Hidden server-home-link inside iframe');
        }
    };

    // Watch for DOM changes so Admin stays hidden
    const navBar = iframeDoc.querySelector('nav');
    if (navBar) {
        new MutationObserver(hideAdmin).observe(navBar, { childList: true, subtree: true });
        hideAdmin();
    }

    // Click Monitor link
    console.log('Clicking monitor-link inside iframe...');
    monitorEl.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true, view: window }));

    // Double-check monitor loaded
    const checkMonitorLoaded = setInterval(() => {
        const monitorPageEl = iframeDoc.querySelector('#integration-admin-ui-container');
        if (monitorPageEl) {
            clearInterval(checkMonitorLoaded);
            console.log('Monitor page loaded inside iframe');
            hideAdmin();
			const overlay = document.getElementById('overlayBlocker');
			if (overlay) {
			  
			  setTimeout(() => {
				overlay.style.display = 'none';
				overlay.style.pointerEvents = 'none';
				console.log('Overlay hidden after monitor load');
			  }, 3000);
			}
        }
    }, 300);
}

</script>


</body>
</html>

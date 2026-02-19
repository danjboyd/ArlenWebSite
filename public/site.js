(() => {
  const initFeatureSpotlights = () => {
    const modalRoot = document.querySelector("[data-spotlight-root]");
    const dialog = modalRoot ? modalRoot.querySelector(".spotlight-dialog") : null;
    if (!modalRoot || !dialog) {
      return;
    }

    const openButtons = Array.from(document.querySelectorAll("[data-spotlight-open]"));
    const panels = Array.from(modalRoot.querySelectorAll("[data-spotlight-panel]"));
    const closeButtons = Array.from(modalRoot.querySelectorAll("[data-spotlight-close]"));
    if (openButtons.length === 0 || panels.length === 0) {
      return;
    }

    let previousFocus = null;

    const setPanel = (panelId) => {
      let matched = false;
      panels.forEach((panel) => {
        const isActive = panel.dataset.spotlightPanel === panelId;
        panel.classList.toggle("is-active", isActive);
        if (isActive) {
          matched = true;
        }
      });

      if (!matched) {
        panels[0].classList.add("is-active");
      }
    };

    const closeModal = () => {
      if (modalRoot.hidden) {
        return;
      }
      modalRoot.hidden = true;
      document.body.classList.remove("modal-open");
      if (previousFocus && typeof previousFocus.focus === "function") {
        previousFocus.focus();
      }
    };

    const openModal = (panelId, trigger) => {
      previousFocus = trigger || document.activeElement;
      setPanel(panelId);
      modalRoot.hidden = false;
      document.body.classList.add("modal-open");
      dialog.focus();
    };

    openButtons.forEach((button) => {
      button.addEventListener("click", () => {
        openModal(button.dataset.spotlightOpen, button);
      });
    });

    closeButtons.forEach((button) => {
      button.addEventListener("click", closeModal);
    });

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && !modalRoot.hidden) {
        event.preventDefault();
        closeModal();
      }
    });
  };

  const initCodeTabs = () => {
    const tabSets = Array.from(document.querySelectorAll("[data-code-tabs]"));
    tabSets.forEach((tabSet) => {
      const buttons = Array.from(tabSet.querySelectorAll("[data-tab-id]"));
      const panels = Array.from(tabSet.querySelectorAll("[data-tab-panel]"));
      if (buttons.length === 0 || panels.length === 0) {
        return;
      }

      const setActive = (activeId) => {
        buttons.forEach((button) => {
          const isActive = button.dataset.tabId === activeId;
          button.classList.toggle("is-active", isActive);
          button.setAttribute("aria-selected", isActive ? "true" : "false");
          button.setAttribute("tabindex", isActive ? "0" : "-1");
        });

        panels.forEach((panel) => {
          panel.classList.toggle("is-active", panel.dataset.tabPanel === activeId);
        });
      };

      buttons.forEach((button) => {
        button.addEventListener("click", () => {
          setActive(button.dataset.tabId);
        });
      });

      const initial = buttons.find((button) => button.classList.contains("is-active"));
      setActive(initial ? initial.dataset.tabId : buttons[0].dataset.tabId);
    });
  };

  const onReady = () => {
    document.body.classList.add("loaded");
    initFeatureSpotlights();
    initCodeTabs();

    const revealItems = Array.from(document.querySelectorAll(".reveal"));
    if (revealItems.length === 0) {
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.2, rootMargin: "0px 0px -8% 0px" }
    );

    revealItems.forEach((item) => observer.observe(item));
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", onReady);
    return;
  }

  onReady();
})();

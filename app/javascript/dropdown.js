document.addEventListener("DOMContentLoaded", function () {
  const dropdowns = document.querySelectorAll('[data-rating-dropdown]');

  dropdowns.forEach(container => {
    const trigger = container.querySelector('[data-dropdown-trigger]');
    const menu = container.querySelector('[data-dropdown-menu]');
    const currentSpan = container.querySelector('.rd-current');

 
    function openMenu() {
      menu.classList.add('show');
      trigger.setAttribute('aria-expanded', 'true');
      document.addEventListener('click', outsideClick);
    }
    function closeMenu() {
      menu.classList.remove('show');
      trigger.setAttribute('aria-expanded', 'false');
      document.removeEventListener('click', outsideClick);
    }

    function outsideClick(e) {
      if (!container.contains(e.target)) closeMenu();
    }


    trigger.addEventListener('click', () => {
      menu.classList.contains('show') ? closeMenu() : openMenu();
    });


    menu.querySelectorAll('li').forEach(li => {
      li.addEventListener('click', () => {
        currentSpan.innerHTML = li.dataset.value;
        closeMenu();
      });
    });
  });
});
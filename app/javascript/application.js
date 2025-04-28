// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.addEventListener('DOMContentLoaded', () => {
  const sections = document.querySelectorAll('.toggle-section');

  sections.forEach(section => {
    section.addEventListener('click', () => {
      // Désactive toutes les sections
      sections.forEach(s => {
        s.classList.remove('active-section');
        s.querySelector('.details').classList.remove('visible');
      });

      // Active la section cliquée
      section.classList.add('active-section');
      section.querySelector('.details').classList.add('visible');
    });
  });
});

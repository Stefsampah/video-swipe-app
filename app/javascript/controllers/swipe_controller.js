import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video"]

  connect() {
    console.log("Swipe controller connected")
    // Initialiser le compteur de swipes depuis le localStorage ou à 0
    this.swipeCount = parseInt(localStorage.getItem('swipeCount') || 0)
  }

  like() {
    this.handleSwipe(true)
  }

  dislike() {
    this.handleSwipe(false)
  }

  async handleSwipe(liked) {
    const videoId = this.element.dataset.videoId
    const playlistId = this.element.dataset.playlistId
    const gameId = this.element.dataset.gameId

    try {
      const response = await fetch('/swipes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          video_id: videoId,
          playlist_id: playlistId,
          liked: liked
        })
      })

      if (response.ok) {
        // Incrémenter le compteur de swipes
        this.swipeCount++
        // Sauvegarder le compteur dans le localStorage
        localStorage.setItem('swipeCount', this.swipeCount.toString())
        
        // Vérifier si nous avons atteint 10 swipes
        if (this.swipeCount >= 10) {
          // Réinitialiser le compteur
          localStorage.setItem('swipeCount', '0')
          // Rediriger vers la page de résultats
          window.location.href = `/playlists/${playlistId}/games/${gameId}/results`
        } else {
          // Sinon, recharger la page pour afficher la prochaine vidéo
          window.location.reload()
        }
      } else {
        console.error('Erreur lors du swipe')
      }
    } catch (error) {
      console.error('Erreur:', error)
    }
  }
} 
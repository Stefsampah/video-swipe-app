import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video"]

  connect() {
    console.log("Swipe controller connected")
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
        // Recharger la page pour afficher la prochaine vidéo
        window.location.reload()
      } else {
        console.error('Erreur lors du swipe')
      }
    } catch (error) {
      console.error('Erreur:', error)
    }
  }
} 
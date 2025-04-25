class Score < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :playlist_id, presence: true

  # Méthodes pour calculer les différents types de scores
  def self.calculate_top_engager_scores
    # Récupérer tous les swipes groupés par utilisateur
    swipes_by_user = Swipe.group(:user_id)
                         .select('user_id, COUNT(*) as total_swipes')
                         .order('total_swipes DESC')
    
    # Calculer les points (1 point par swipe)
    swipes_by_user.map do |swipe|
      {
        user_id: swipe.user_id,
        points: swipe.total_swipes,
        badges: ["Top engager du jour"]
      }
    end
  end

  def self.calculate_best_ratio_scores
    # Récupérer les likes et dislikes par utilisateur
    interactions = Swipe.group(:user_id)
                       .select("user_id, 
                              SUM(CASE WHEN action = 'like' THEN 1 ELSE 0 END) as likes,
                              SUM(CASE WHEN action = 'dislike' THEN 1 ELSE 0 END) as dislikes")
    
    interactions.map do |interaction|
      total = interaction.likes + interaction.dislikes
      next if total.zero?

      ratio = (interaction.likes.to_f / total) * 100
      
      points = case ratio
               when 40..60 then 5
               when 20..40, 60..80 then 3
               else 1
               end

      {
        user_id: interaction.user_id,
        points: points,
        ratio: ratio.round(2),
        badges: ratio.between?(40, 60) ? ["Best Ratio du jour"] : []
      }
    end.compact
  end

  def self.calculate_wise_critic_scores
    # Récupérer les likes et dislikes par utilisateur
    interactions = Swipe.group(:user_id)
                       .select("user_id, 
                              SUM(CASE WHEN action = 'like' THEN 1 ELSE 0 END) as likes,
                              SUM(CASE WHEN action = 'dislike' THEN 1 ELSE 0 END) as dislikes")
    
    interactions.map do |interaction|
      total = interaction.likes + interaction.dislikes
      next if total.zero?

      like_proportion = (interaction.likes.to_f / total) * 100
      dislike_proportion = (interaction.dislikes.to_f / total) * 100
      gap = (like_proportion - dislike_proportion).abs

      points = case gap
               when 0..20 then 5
               when 20..50 then 3
               else 1
               end

      {
        user_id: interaction.user_id,
        points: points,
        gap: gap.round(2),
        badges: gap <= 20 ? ["Wise Critic du jour"] : []
      }
    end.compact
  end

  def self.calculate_total_scores
    top_engager = calculate_top_engager_scores
    best_ratio = calculate_best_ratio_scores
    wise_critic = calculate_wise_critic_scores

    # Combiner tous les scores
    combined_scores = {}
    
    [top_engager, best_ratio, wise_critic].each do |scores|
      scores.each do |score|
        user_id = score[:user_id]
        combined_scores[user_id] ||= { points: 0, badges: [] }
        combined_scores[user_id][:points] += score[:points]
        combined_scores[user_id][:badges].concat(score[:badges])
      end
    end

    # Convertir en tableau pour la vue
    combined_scores.map do |user_id, data|
      {
        user_id: user_id,
        points: data[:points],
        badges: data[:badges]
      }
    end
  end

  def badges
    badges = []
  
    # Ajout du badge "Best Ratio du jour"
    interaction = Swipe.group(:user_id).select("user_id, 
      SUM(CASE WHEN action = 'like' THEN 1 ELSE 0 END) as likes, 
      SUM(CASE WHEN action = 'dislike' THEN 1 ELSE 0 END) as dislikes").find_by(user_id: user_id)
  
    if interaction.present?
      total = interaction.likes + interaction.dislikes
      if total > 0
        ratio = (interaction.likes.to_f / total) * 100
        badges << "Best Ratio du jour" if ratio.between?(40, 60)
  
        # Ajout du badge "Wise Critic du jour"
        like_proportion = (interaction.likes.to_f / total) * 100
        dislike_proportion = (interaction.dislikes.to_f / total) * 100
        gap = (like_proportion - dislike_proportion).abs
        badges << "Wise Critic du jour" if gap <= 20
      end
    end
  
    badges
  end
   
end

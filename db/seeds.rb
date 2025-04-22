# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Création d'un utilisateur admin
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = '123456'
  user.admin = true
end

# Création d'un utilisateur normal
user = User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = '234567'
end

# Playlist 1: Musique Pop
pop_playlist = Playlist.find_or_create_by!(title: 'Top Pop Hits 2024') do |playlist|
  playlist.description = 'Les meilleurs hits pop du moment'
end

# Vidéos pour la playlist Pop
pop_videos = [
  { title: 'Dua Lipa - Houdini', youtube_id: 'suAR1PYFNYA' },
  { title: 'Tate McRae - Greedy', youtube_id: 'To4SWGZkEPk' },
  { title: 'Doja Cat - Paint The Town Red', youtube_id: 'm4_9TFeMfJE' },
  { title: 'Olivia Rodrigo - vampire', youtube_id: 'RlPNh_PBZb4' },
  { title: 'Billie Eilish - What Was I Made For?', youtube_id: 'cW8VLC9nnTo' },
  { title: 'Miley Cyrus - Flowers', youtube_id: 'G7KNmW9a75Y' },
  { title: 'SZA - Kill Bill', youtube_id: 'MSRcC626prw' },
  { title: 'Taylor Swift - Anti-Hero', youtube_id: 'b1kbLwvqugk' },
  { title: 'The Weeknd - Die For You', youtube_id: 'uPD0QOGTmMI' },
  { title: 'Ed Sheeran - Eyes Closed', youtube_id: 'u6wOyMUs74I' }
]

pop_videos.each do |video|
  pop_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist 2: Hip Hop
hip_hop_playlist = Playlist.find_or_create_by!(title: 'Best Hip Hop Music') do |playlist|
  playlist.description = 'Les meilleurs morceaux de hip hop'
end

# Vidéos pour la playlist Hip Hop
hip_hop_videos = [
  { title: 'ENTRE NOUS DEUX · Didi B · Doupi Papillon', youtube_id: 'qMNl8T42krY' },
  { title: 'Nothing Without God · POPCAAN', youtube_id: 'wFRyzB170sk' },
  { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
  { title: 'Travis Scott - She Going Dumb', youtube_id: 'tN82cGi9kUc' },
  { title: 'Quavo, Lil Baby - Legends', youtube_id: '4cCzuTQ49V8' },
  { title: 'Skillibeng - New Gears', youtube_id: 'Yubuf7k1WZM' },
  { title: 'TOUT VA BIEN · Didi B', youtube_id: 'WdwasPVKGQo' },
  { title: 'Toosii - Party Girl Anthem', youtube_id: 'x4xDmrvHTY0' },
  { title: 'YE - CIRCLES', youtube_id: 'SWPeFW7Bd74' },
  { title: 'Didi B - Good vibes', youtube_id: 'wLdtn45riSc' }
]

hip_hop_videos.each do |video|
  hip_hop_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist 3: Reggae
reggae_playlist = Playlist.find_or_create_by!(title: 'Best Reggae Hits') do |playlist|
  playlist.description = 'Les meilleurs morceaux de reggae'
end

# Vidéos pour la playlist Reggae
reggae_videos = [
  { title: 'Bob Marley - No Woman No Cry', youtube_id: 'IT8XvzIfi4U' },
  { title: 'UB40 - Red Red Wine', youtube_id: 'zXt56MB-3vc' },
  { title: 'Bob Marley - Three Little Birds', youtube_id: 'zaGUr6wzyT8' },
  { title: 'Damian Marley - Welcome To Jamrock', youtube_id: 'mzDbEZ5t5-E' },
  { title: 'Bob Marley - Jamming', youtube_id: 'oFRbZJXjWIA' },
  { title: 'UB40 - Kingston Town', youtube_id: '4zL3Cf5xrOo' },
  { title: 'Bob Marley - One Love', youtube_id: 'vdB-8eLEW8g' },
  { title: 'Inner Circle - Sweat', youtube_id: 'yG07WSuVQ7I' },
  { title: 'Bob Marley - Could You Be Loved', youtube_id: 'Hu0z6zyci2M' },
  { title: 'UB40 - Can\'t Help Falling In Love', youtube_id: 'vGJTaP6anOU' }
]

reggae_videos.each do |video|
  reggae_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Création de quelques scores pour tester
Score.find_or_create_by!(user: user, playlist: pop_playlist) do |score|
  score.points = 7
end

Score.find_or_create_by!(user: user, playlist: hip_hop_playlist) do |score|
  score.points = 5
end

Score.find_or_create_by!(user: user, playlist: reggae_playlist) do |score|
  score.points = 8
end

Score.find_or_create_by!(user: admin, playlist: pop_playlist) do |score|
  score.points = 9
end

Score.find_or_create_by!(user: admin, playlist: hip_hop_playlist) do |score|
  score.points = 6
end

Score.find_or_create_by!(user: admin, playlist: reggae_playlist) do |score|
  score.points = 7
end

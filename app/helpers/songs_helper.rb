module SongsHelper

	def download_url_for(song_key)
		"../music/#{song_key}.mp3"
	end

end
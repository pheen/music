class SongsController < ApplicationController
  def index
  	@songs = Hash.new

    # loop music folder contents into hash
  	Dir.glob('public/music/*.mp3').each do |file|
  		mp3 = Mp3Info.open(file)

  		@songs["#{mp3.tag.title}"] = {
  			:artist => "#{mp3.tag.artist}",
  			:album => "#{mp3.tag.album}",
  			:year => "#{mp3.tag.year}",
  			:tracknum => "#{mp3.tag.tracknum}",
  			:comments => "#{mp3.tag.comments}",
  			:genre => "#{mp3.tag.genre_s}"
  		}
  	end
  end

  def upload
    begin
      # loop through array POST for each song as ActionDispatch::Http::UploadedFile
      params[:mp3file].each do |file|
        # create new empty file
        File.open("public/music/#{file.original_filename}", 'wb') do |f|
          f.write(file.read)
          f.fsync
        end

        # grab mp3 details & rename
        mp3 = Mp3Info.open("public/music/#{file.original_filename}")
        File.rename("public/music/#{file.original_filename}", "public/music/#{mp3.tag.artist} - #{mp3.tag.title}.mp3")
      end

      redirect_to root_path
    rescue
      render :text => "#{Mp3Info.open(params[:mp3file][0])}"
    end
  end

  def delete
    if (params[:song])
      File.delete("public/music/#{params[:song]}")
      redirect_to root_path
    else
      render :text => "No song was found to delete!"
    end
  end

  private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/,'_')
  end

end
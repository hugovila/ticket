require 'rubygems'
require 'sinatra'

get '/' do
	"Get Your <a href=\"/ticket/data\">Ticket</a>"
end

get '/ticket/data' do
	erb :ticket_data
end

post '/ticket/template' do
	erb :ticket_template
end

post '/ticket/print' do

	#erb :index, :layout => :ticket_print_black
	renderir(params[:template])

end

get '/ticket/print/:name/:surname/:where/:when/:template' do
	
	renderir(params[:template])

end

def renderir(template)
    result = :ticket_print

	result = :ticket_print_black if template == "black_night"

	result = :ticket_print_moon if template == "moon_night"

	result = :ticket_print_starry if template == "starry_night"

	erb result #, :layout => :ticket_print_black
end

not_found do
  status 404
  'not found'
end


#templates = { "night" => :ticket_print, "black_night" => :ticket_print_black, "moon_night" => :ticket_print_moon, "starry_night" => :ticket_print_starry }

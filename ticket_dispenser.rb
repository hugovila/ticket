require 'rubygems'
require 'sinatra'

templates = { :black_night => :ticket_print_black, :moon_night => :ticket_print_moon, :starry_night => :ticket_print_starry }

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
	renderize(params[:template])

end

get '/ticket/print/:name/:surname/:where/:when/:template' do
	
	renderize(params[:template])

end

def renderize(template)

	templates = { :black_night => :ticket_print_black, :moon_night => :ticket_print_moon, :starry_night => :ticket_print_starry }
   #templates = { :black_night => :template_ticket_black, :moon_night => :template_ticket_moon, :starry_night => :template_ticket_starry }

	params[:title] = "Ticket Dispenser"

	template = template.to_sym

	template_selected = :default_template

	template_selected = template if templates.has_key?(template)

	result = templates[template_selected]

	erb result

end


not_found do
  status 404
  'not found'
end



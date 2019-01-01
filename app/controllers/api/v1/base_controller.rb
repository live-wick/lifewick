class Api::V1::BaseController < ApplicationController
	skip_before_action :verify_authenticity_token
	 before_action :doorkeeper_authorize!
end

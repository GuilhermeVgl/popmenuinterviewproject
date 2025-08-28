class ImportsController < ApplicationController
  def create
    file = params[:file]
    unless file
      render json: { error: "File not provided" }, status: :bad_request
      return
    end

    begin
      json_data = JSON.parse(file.read)
      result = RestaurantDataImporter.call(json_data)

      render json: result.logs, status: result.success? ? :created : :unprocessable_entity
    rescue JSON::ParserError
      render json: { error: "Invalid JSON format" }, status: :bad_request
    rescue StandardError => e
      Rails.logger.error e.full_message

      render json: { error: "An internal error occurred. Please try again later." }, status: :internal_server_error
    end
  end
end

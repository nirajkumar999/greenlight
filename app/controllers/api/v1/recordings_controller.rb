# frozen_string_literal: true

module Api
  module V1
    class RecordingsController < ApiController
      skip_before_action :verify_authenticity_token # TODO: - Revisit this.

      # GET /api/v1/recordings.json
      # Returns: { data: Array[serializable objects(recordings)] , errors: Array[String] }
      # Does: Returns all the Recordings from all the current user's rooms

      def index
        recordings = current_user.recordings&.search(params[:search])

        render_json(data: recordings, status: :ok, include: :formats)
      end

      def destroy
        # TODO: - Need to change this to work preferably with after_destroy in recordings model
        BigBlueButtonApi.new.delete_recordings(record_ids: params[:id])

        Recording.destroy_by(record_id: params[:id])

        render_json(status: :ok)
      end

      def resync
        RecordingsSync.new(user: current_user).call

        render_json(status: :ok)
      end
    end
  end
end
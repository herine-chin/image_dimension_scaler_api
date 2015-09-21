module Api
  module V1
    class DimensionsController < ApplicationController
      before_action :parse_request, :validate_params

      def parse_request
        begin
          if !box || !images
            details = "#{request.path} requires a 'bounding_box' AND 'image_dimensions'."
            error = { code: 400, exception: 'MissingParameter', message: 'Missing a required parameter.', details: details }
            render(json: error)
          else
            params['bounding_box'] = JSON.parse(box)
            params['image_dimensions'] = JSON.parse(images)
          end
        rescue
          error = { code: 400, exception: 'InvalidJson', message: 'The data provided was missing or invalid json.' }
          render(json: error)
        end
      end

      def box
        params['bounding_box']
      end

      def images
        params['image_dimensions']
      end

      def validate_params
        if !(box.is_a? Array) || !(images.is_a? Array)
          details = "#{request.path} requires the 'bounding_box' and 'image_dimensions' value to be an array."
          error = { code: 400, exception: 'InvalidParameter', message: 'Incorrect parameter type.', details: details }
        elsif box.size != 2
          details = "#{request.path} requires 'bounding_box' array to have values for width and height only e.g. [100,200]."
          error = { code: 400, exception: 'InvalidParameter', message: 'Incorrect parameter values.', details: details }
        elsif images.size.odd?
          details = "#{request.path} requires 'image_dimension' array to have width and height pairs e.g. [100,200,111,999]."
          error = { code: 400, exception: 'InvalidParameter', message: 'Incorrect parameter values.', details: details }
        end
        render(json: error) if error
      end

      def process_image_dimensions
        if valid_dimension? box
          images.each_slice(2) do |image|
            if valid_dimension? image
              scale_dimension_for image
            else
              details = "#{request.path} requires 'image_dimensions' array to contain integers greater than 0."
              error = { code: 400, exception: 'InvalidParameter', message: 'Incorrect parameter values.', details: details }
              break
            end
          end
        else
          details = "#{request.path} requires 'bounding_box' array to contain integers greater than 0."
          error = { code: 400, exception: 'InvalidParameter', message: 'Incorrect parameter values.', details: details }
        end

        if error
          render(json: error)
        else
          results = { scaled_dimensions: scaled_dimensions, bounding_box: box }
          render(json: results)
        end
      end

      def valid_dimension? dim
        if dim.first.is_a?(Integer) && dim.last.is_a?(Integer)
          if dim.first > 0 && dim.last > 0
            true
          else
            false
          end
        else
          false
        end
      end

      def scale_dimension_for image
        scaled_dimensions << (image.first / scale_ratio(image)).round
        scaled_dimensions << (image.last / scale_ratio(image)).round
      end

      def scale_ratio image
        width_ratio = image.first.to_f / box.first
        height_ratio = image.last.to_f / box.last

        if width_ratio > height_ratio
          scale_ratio = width_ratio
        else
          scale_ratio = height_ratio
        end
        scale_ratio
      end

      def scaled_dimensions
        @scaled_dimensions ||= []
      end

    end
  end
end
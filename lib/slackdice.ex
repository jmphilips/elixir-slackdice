defmodule Slackdice.Router do
  use Trot.Router

    get "/" do
        conn = put_resp_content_type(conn, "application/json")

        message = %{"response_type" => "in_channel", "text" => "#{convert_roll_to_string(3)}"}
        |> Poison.encode!([])

        send_resp(conn, 200, message)
    end

    


    def create_dice do 
        [1, 2, 3, 4, 5, 6]
    end

    def roll_dice(dice) do
        [roll | _] = Enum.shuffle(dice)
        roll
    end

    def rolled_number do 
        create_dice |> roll_dice   
    end


    def number_of_rolls(number, old_list) when number == 0 do
        %{numbers: old_list, sum: Enum.sum(old_list)}
    end

    def number_of_rolls(number, old_list) do
        number_of_rolls(number - 1, multiple_rolls(old_list))
    end


    def number_of_rolls(number) do 
        number_of_rolls(number - 1, [rolled_number])
    end

    def multiple_rolls(old_list) do
        List.flatten([rolled_number | old_list])
    end

    def roll_map_to_string(map) do
      Integer.to_string(map.sum)  
    end

    def convert_roll_to_string(number) do
        number |> number_of_rolls |> roll_map_to_string
    end

    import_routes Trot.NotFound
end

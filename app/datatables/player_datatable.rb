class PlayerDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id:         { source: "Player.id", searchable: false },
      first_name: { source: "Player.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "Player.last_name",  cond: :like, searchable: true },
      position:      { source: "Player.position", searchable: false },
      gp:        { source: "Player.gp", searchable: false },
      mpg:        { source: "Player.mpg", searchable: false },
      ppg:        { source: "Player.ppg", searchable: false },
      rpg:        { source: "Player.rpg", searchable: false },
      apg:        { source: "Player.apg", searchable: false },
      spg:        { source: "Player.spg", searchable: false },
      bpg:        { source: "Player.bpg", searchable: false },
      topg:        { source: "Player.topg", searchable: false },
      fg_perc:        { source: "Player.fg_perc", searchable: false },
      fg3_perc:        { source: "Player.fg3_perc", searchable: false },
      ft_perc:        { source: "Player.ft_perc", searchable: false },
      fppg:        { source: "Player.fppg", searchable: false },
      current_salary:        { source: "Player.current_salary", searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        id:         record.id,
        first_name: record.first_name,
        last_name:  record.last_name,
        position:   record.position,
        gp:         record.gp,
        mpg:        record.mpg,
        ppg:        record.ppg,
        rpg:        record.rpg,
        apg:        record.apg,
        spg:        record.spg,
        bpg:        record.bpg,
        topg:       record.topg,
        fg_perc:    record.fg_perc,
        fg3_perc:   record.fg3_perc,
        ft_perc:    record.ft_perc,
        fppg:       record.fppg,
        current_salary:     record.current_salary,
        DT_RowId:   record.id
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Player.left_outer_joins(:leagues).where.not(leagues: { id: current_league })
    .or(Player.left_outer_joins(:leagues).where(leagues: { id: nil }))
  end

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

end

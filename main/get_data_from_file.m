function table = get_data_from_file(filename)
    gpxParser = XMLParser(filename);
    results = gpxParser.Parse();
    
    table = create_master_table(results);

end


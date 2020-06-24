Public Class GoogleChartOpportunity{

    public String opportunitiesByStage{get;set;}
    public String opportunityByStageColors{get;set;}
   
    public String opportunityAmountByStage{get;set;}
    public String opportunityAmountByStageColors{get;set;}
   
    public GoogleChartOpportunity(){
   
    // Default Colors for Each stage.
        Map<String,String> mapStageNameToColor = new Map<String,String>();
            mapStageNameToColor.put('Prospecting','#25A6DF');
            mapStageNameToColor.put('Qualification','#676566');
            mapStageNameToColor.put('Needs Analysis','#585858');
            mapStageNameToColor.put('Value Proposition','#25A7E1');
            mapStageNameToColor.put('Id. Decision Makers','#373739');
            mapStageNameToColor.put('Perception Analysis','#676566');
            mapStageNameToColor.put('Proposal/Price Quote','#373739');
            mapStageNameToColor.put('Negotiation/Review','#373739');
            mapStageNameToColor.put('Closed Won','#676477');
       
   
     opportunitiesByStage = '';
     opportunityByStageColors = '';
       
        for(AggregateResult ar : [Select count(Id), StageName from Opportunity Group By StageName]){
            String oppStageName = String.ValueOf(ar.get('StageName'));
            opportunityByStageColors = (opportunityByStageColors == '' ? mapStageNameToColor.get(oppStageName) : opportunityByStageColors+','+mapStageNameToColor.get(oppStageName));
            opportunitiesByStage = (opportunitiesByStage == '' ? oppStageName+'#'+Integer.valueOf(ar.get('expr0')) : opportunitiesByStage+'~'+oppStageName+'#'+Integer.valueOf(ar.get('expr0')));
        }
       
     opportunityAmountByStage = '';
     opportunityAmountByStageColors = '';
       
        for(AggregateResult ar : [Select SUM(Amount), StageName from Opportunity Group By StageName]){
            String oppStageName = String.ValueOf(ar.get('StageName'));
            opportunityAmountByStageColors = (opportunityAmountByStageColors == '' ? mapStageNameToColor.get(oppStageName) : opportunityAmountByStageColors+','+mapStageNameToColor.get(oppStageName));
            opportunityAmountByStage = (opportunityAmountByStage == '' ? String.ValueOf(ar.get('StageName'))+'#'+Double.valueOf(ar.get('expr0')) : opportunityAmountByStage+'~'+String.ValueOf(ar.get('StageName'))+'#'+Double.valueOf(ar.get('expr0')));
        }
    }      
}
//
//  TimeYaConstants.h
//  TimeYa2
//
//  Created by PartyMan on 11/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

//
//  TimeYaConstants.h
//  TimeYa
//
//  Created by PartyMan on 10/9/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#ifndef TimeYa_TimeYaConstants_h
#define TimeYa_TimeYaConstants_h

#define APP_LOG_LEVEL LOG_LEVEL_VERBOSE;

//Core Data Document Handler
#define CORE_DATA_DOCUMENT_ERROR_DOMAIN @"CoreDataErrorDomain"
#define DEFAULT_DOCUMENT_NAME @"AppCoreDataDocument"
#define MAX_NO_DELETE_TRIES 3
#define MAX_NO_SAVE_TRIES 3

//Entity Data Model Keys
#define ATTRIBUTES_KEY @"attributes"

//Workout Entity Constants
#define WORKOUT_ENTITY_NAME @"Workout"

#define WORKOUT_LAST_RUN_KEY @"lastRun"
#define WORKOUT_NAME_KEY @"name"
#define WORKOUT_ACTIVITIES_KEY @"activities"

//Activity Entity Constants
#define ACTIVITY_ENTITY_NAME @"Activity"

#define ACTIVITY_NAME_KEY @"name"
#define ACTIVITY_WORKOUT @"workout"

//Exercise Entity Constants
#define EXERCISE_ENTITY_NAME @"Exercise"

#define EXERCISE_REPS_KEY @"reps"
#define EXERCISE_ROUNDS_KEY @"rounds"
#define EXERCISE_SETS_KEY @"sets"
#define EXERCISE_SET_REST_TIME_KEY @"setRestTime"
#define EXERCISE_SET_REST_TIME_UNIT_KEY @"setRestTimeUnit"
#define EXERCISE_WEIGHT_KEY @"weight"
#define EXERCISE_WEIGHT_UNIT_KEY @"weightUnit"
#define EXERCISE_TIME_KEY @"time"
#define EXERCISE_TIME_UNIT_KEY @"timeUnit"
#define EXERCISE_DISTANCE_KEY @"distance"
#define EXERCISE_DISTANCE_UNIT_KEY @"distanceUnit"

//Exercise Entity Validation Keys
#define EXERCISE_WEIGHT_UNIQUE_ATTR_ERROR @"WeightUniqueAttributeError"
#define EXERCISE_SETS_REPS_ATTR_ERROR @"SetsRepsAttributeError"
#define EXERCISE_DISTANCE_MISSING_UNIT_ERROR @"DistanceMissingUnitsError"
#define EXERCISE_TIME_MISSING_UNIT_ERROR @"TimeMissingUnitsError"
#define EXERCISE_WEIGHT_MISSING_UNIT_ERROR @"WeightMissingUnitsError"
#define EXERCISE_SET_REST_TIME_MISSING_UNIT_ERROR @"SetRestTimeMissingUnitsError"

//Group Entity Constants
#define GROUP_ENTITY_NAME @"Group"

#define GROUP_ACTIVITIES_KEY @"activities"


//Attribute Metrics
#define ATTR_MIN_VALUE_KEY @"attrMinVal"
#define ATTR_MAX_VALUE_KEY @"attrMaxVal"
#define UNIT_TYPE_KEY @"unitType"
#define UNIT_VALUE_KEY @"unitValue"
#define ATTR_DISPLAY_ORDER @"displayOrder"
#define METRIC_UNIT_SUFFIX @"Unit"

//WEIGHT_UNIT_ENUM
#define WEIGHT_UNIT_ENUM @"WeightUnitType"

typedef enum WeightUnitType {
    WeightUnitKilograms = 100,
    WeightUnitPounds = 200
    
}WeightUnitType;


//DISTANCE_UNIT_ENUM
#define DISTANCE_UNIT_ENUM @"DistanceUnitType"
typedef enum DistanceUnitType{
    DistanceUnitMeters = 100,
    DistanceUnitMiles = 200
}DistanceUnitType;


//TIME_UNIT_ENUM
#define TIME_UNIT_ENUM @"TimeUnitType"
typedef enum TimeUnitType{
    TimeUnitSeconds = 100
}TimeUnitType;


//WorkoutList Entity Constants
#define WORKOUT_LIST_ENTITY_NAME @"WorkoutList"
#define WORKOUT_LIST_WORKOUT @"workout"

//WorkoutListActivity Entity Constants
#define WORKOUT_LIST_ACTIVITY_ENTITY_NAME @"WorkoutListActivity"
#define WORKOUT_LIST_ACTIVITY_ACTIVITY @"activity"
#define WORKOUT_LIST_ACTIVITY_ROOT @"root"
#define WORKOUT_LIST_ACTIVITY_POSITION @"position"

//WorkoutExecution Entity Constants
#define WORKOUT_EXECUTION_ENTITY_NAME @"WorkoutExecution"
#define WORKOUT_EXECUTION_ACTIVE @"active"

//ActivityExecution Entity Constants
#define ACTIVITY_EXECUTION_ENTITY_NAME @"ActivityExecution"
#define ACTIVITY_EXECUTION_ACTIVE @"active"

//View Controllers
#define WORKOUT_TVC_ID @"ShowActivities"
#define EDIT_ACTIVITY_TVC_ID @"EditActivity"
#define WORKOUT_EXECUTOR_ID @"WorkoutExecutor"

//WorkoutPacer
#define WORKOUT_PACER_INTERVAL 1.0f
#define WORKOUT_PACER_NOTIFICATION @"WorkoutPacerBeatNotification"


#endif

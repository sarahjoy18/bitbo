<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TChildenProfile
 * 
 * @property int $CHILDREN_ID
 * @property int $RESIDENT_ID
 * @property int $BIRTH_ORDER
 * @property int $IS_REGISTERED
 * @property string $BORN_AT
 * @property string $CHILDER_MOTHER_TONGUE
 * @property string $CHILDREN_OTHER_DIALECT
 * @property string $CHILDREN_HEIGHT
 * @property string $CHILDREN_WEIGHT
 * @property int $DOES_IT_HAVE_ECCD_CARD
 * @property int $DOES_IT_HAVE_MOTHER_CHILD_BOOK
 * @property int $DOES_IT_HAVE_OTHERS
 * @property int $VACCINATION_BCG
 * @property int $VACCINATION_DPT
 * @property int $VACCINATION_ORAL_POLIO
 * @property int $VACCINATION_HEPA_B
 * @property int $VACCINATION_MEASLES
 * @property int $VACCINATION_OTHERS
 * @property int $DEFORMITY_HARE_LIP
 * @property int $DEFORMITY_DISABLE_LEG
 * @property int $DEFORMITY_CROSS_EYED
 * @property int $DEFORMITY_DISABLE_ARM_LEG
 * @property int $DEFORMITY_DEAF
 * @property int $DEFORMITY_BLIND
 * @property int $PROBLEMS_WITH_BEHAVIOR
 * @property int $PROBLEMS_WITH_SPEAKING
 * @property int $PROBLEMS_WITH_HEARING
 * @property int $PROBLEMS_WITH_VISION
 * @property int $IS_LEFT_HANDED
 * @property int $CHILDHOOD_EXP_NURSERY
 * @property int $CHILDHOOD_EXP_KINDERGARTEN
 * @property int $CHILDHOOD_EXP_PREPARATORY
 * @property int $LEARNS_AT_HOME_W_PARENTS
 * @property int $LEARNS_AT_HOME_W_NOBODY
 * @property int $LEARNS_AT_HOME_W_SIBLINGS
 * @property int $LEARNS_AT_HOME_W_RELATIVES
 * @property int $LEARNS_AT_HOME_W_MAID
 * @property int $LEARNS_AT_HOME_W_OTHERS
 * @property int $INTERACTS_W_OLDER_SIBLINGS
 * @property int $INTERACTS_W_YOUNGER_SIBLINGS
 * @property int $INTERACTS_W_SAME_AGE
 * @property int $EATS_MEAL_BEFORE_SCHOOL
 * @property int $HAS_BAON
 * @property string $TRAVEL_TIME_TO_DCC
 * @property string $MODE_TRANSPORTATION_TO_DCC
 * @property string $TRAVEL_TIME_TO_NCDC
 * @property string $MODE_TRANSPORTATION_TO_NCDC
 * @property int $PUBLIC_TRANSPORTATION_ID
 * @property int $TRANSPORTATION_FARE
 * @property string $GOES_TO_SCHOOL_WITH
 * @property string $CHILD_DEVELOPMENT_TEACHER
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \Illuminate\Database\Eloquent\Collection $t_food_eatens
 *
 * @package App\Models
 */
class TChildenProfile extends Eloquent
{
	protected $table = 't_childen_profile';
	protected $primaryKey = 'CHILDREN_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'BIRTH_ORDER' => 'int',
		'IS_REGISTERED' => 'int',
		'DOES_IT_HAVE_ECCD_CARD' => 'int',
		'DOES_IT_HAVE_MOTHER_CHILD_BOOK' => 'int',
		'DOES_IT_HAVE_OTHERS' => 'int',
		'VACCINATION_BCG' => 'int',
		'VACCINATION_DPT' => 'int',
		'VACCINATION_ORAL_POLIO' => 'int',
		'VACCINATION_HEPA_B' => 'int',
		'VACCINATION_MEASLES' => 'int',
		'VACCINATION_OTHERS' => 'int',
		'DEFORMITY_HARE_LIP' => 'int',
		'DEFORMITY_DISABLE_LEG' => 'int',
		'DEFORMITY_CROSS_EYED' => 'int',
		'DEFORMITY_DISABLE_ARM_LEG' => 'int',
		'DEFORMITY_DEAF' => 'int',
		'DEFORMITY_BLIND' => 'int',
		'PROBLEMS_WITH_BEHAVIOR' => 'int',
		'PROBLEMS_WITH_SPEAKING' => 'int',
		'PROBLEMS_WITH_HEARING' => 'int',
		'PROBLEMS_WITH_VISION' => 'int',
		'IS_LEFT_HANDED' => 'int',
		'CHILDHOOD_EXP_NURSERY' => 'int',
		'CHILDHOOD_EXP_KINDERGARTEN' => 'int',
		'CHILDHOOD_EXP_PREPARATORY' => 'int',
		'LEARNS_AT_HOME_W_PARENTS' => 'int',
		'LEARNS_AT_HOME_W_NOBODY' => 'int',
		'LEARNS_AT_HOME_W_SIBLINGS' => 'int',
		'LEARNS_AT_HOME_W_RELATIVES' => 'int',
		'LEARNS_AT_HOME_W_MAID' => 'int',
		'LEARNS_AT_HOME_W_OTHERS' => 'int',
		'INTERACTS_W_OLDER_SIBLINGS' => 'int',
		'INTERACTS_W_YOUNGER_SIBLINGS' => 'int',
		'INTERACTS_W_SAME_AGE' => 'int',
		'EATS_MEAL_BEFORE_SCHOOL' => 'int',
		'HAS_BAON' => 'int',
		'PUBLIC_TRANSPORTATION_ID' => 'int',
		'TRANSPORTATION_FARE' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'BIRTH_ORDER',
		'IS_REGISTERED',
		'BORN_AT',
		'CHILDER_MOTHER_TONGUE',
		'CHILDREN_OTHER_DIALECT',
		'CHILDREN_HEIGHT',
		'CHILDREN_WEIGHT',
		'DOES_IT_HAVE_ECCD_CARD',
		'DOES_IT_HAVE_MOTHER_CHILD_BOOK',
		'DOES_IT_HAVE_OTHERS',
		'VACCINATION_BCG',
		'VACCINATION_DPT',
		'VACCINATION_ORAL_POLIO',
		'VACCINATION_HEPA_B',
		'VACCINATION_MEASLES',
		'VACCINATION_OTHERS',
		'DEFORMITY_HARE_LIP',
		'DEFORMITY_DISABLE_LEG',
		'DEFORMITY_CROSS_EYED',
		'DEFORMITY_DISABLE_ARM_LEG',
		'DEFORMITY_DEAF',
		'DEFORMITY_BLIND',
		'PROBLEMS_WITH_BEHAVIOR',
		'PROBLEMS_WITH_SPEAKING',
		'PROBLEMS_WITH_HEARING',
		'PROBLEMS_WITH_VISION',
		'IS_LEFT_HANDED',
		'CHILDHOOD_EXP_NURSERY',
		'CHILDHOOD_EXP_KINDERGARTEN',
		'CHILDHOOD_EXP_PREPARATORY',
		'LEARNS_AT_HOME_W_PARENTS',
		'LEARNS_AT_HOME_W_NOBODY',
		'LEARNS_AT_HOME_W_SIBLINGS',
		'LEARNS_AT_HOME_W_RELATIVES',
		'LEARNS_AT_HOME_W_MAID',
		'LEARNS_AT_HOME_W_OTHERS',
		'INTERACTS_W_OLDER_SIBLINGS',
		'INTERACTS_W_YOUNGER_SIBLINGS',
		'INTERACTS_W_SAME_AGE',
		'EATS_MEAL_BEFORE_SCHOOL',
		'HAS_BAON',
		'TRAVEL_TIME_TO_DCC',
		'MODE_TRANSPORTATION_TO_DCC',
		'TRAVEL_TIME_TO_NCDC',
		'MODE_TRANSPORTATION_TO_NCDC',
		'PUBLIC_TRANSPORTATION_ID',
		'TRANSPORTATION_FARE',
		'GOES_TO_SCHOOL_WITH',
		'CHILD_DEVELOPMENT_TEACHER',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}

	public function t_food_eatens()
	{
		return $this->hasMany(\App\Models\TFoodEaten::class, 'CHILDREN_ID');
	}
}

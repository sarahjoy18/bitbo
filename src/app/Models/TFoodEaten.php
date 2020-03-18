<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TFoodEaten
 * 
 * @property int $FOOD_EATEN_ID
 * @property int $CHILDREN_ID
 * @property int $VEGETABLE
 * @property int $RICE
 * @property int $CEREAL
 * @property int $PORK
 * @property int $NOODLE
 * @property int $FRUIT_JUICE
 * @property int $CHICKEN
 * @property int $SOUP
 * @property int $MILK
 * @property int $BEEF
 * @property int $BREAD
 * @property int $FISH
 * @property int $FRUIT
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TChildenProfile $t_childen_profile
 *
 * @package App\Models
 */
class TFoodEaten extends Eloquent
{
	protected $table = 't_food_eaten';
	protected $primaryKey = 'FOOD_EATEN_ID';
	public $timestamps = false;

	protected $casts = [
		'CHILDREN_ID' => 'int',
		'VEGETABLE' => 'int',
		'RICE' => 'int',
		'CEREAL' => 'int',
		'PORK' => 'int',
		'NOODLE' => 'int',
		'FRUIT_JUICE' => 'int',
		'CHICKEN' => 'int',
		'SOUP' => 'int',
		'MILK' => 'int',
		'BEEF' => 'int',
		'BREAD' => 'int',
		'FISH' => 'int',
		'FRUIT' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'CHILDREN_ID',
		'VEGETABLE',
		'RICE',
		'CEREAL',
		'PORK',
		'NOODLE',
		'FRUIT_JUICE',
		'CHICKEN',
		'SOUP',
		'MILK',
		'BEEF',
		'BREAD',
		'FISH',
		'FRUIT',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_childen_profile()
	{
		return $this->belongsTo(\App\Models\TChildenProfile::class, 'CHILDREN_ID');
	}
}

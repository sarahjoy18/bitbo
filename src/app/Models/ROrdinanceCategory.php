<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class ROrdinanceCategory
 * 
 * @property int $ORDINANCE_ID
 * @property string $ORDINANCE_CATEGORY_NAME
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_ordinances
 *
 * @package App\Models
 */
class ROrdinanceCategory extends Eloquent
{
	protected $table = 'r_ordinance_category';
	protected $primaryKey = 'ORDINANCE_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ORDINANCE_CATEGORY_NAME',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_ordinances()
	{
		return $this->hasMany(\App\Models\TOrdinance::class, 'ORDINANCE_CATEGORY_ID');
	}
}
